"""
Main Application Entry Point for YMERA Multi-Agent AI System
"""
from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from typing import Dict, Any, List
import uvicorn
import json

from config import settings
from database import init_db, close_db
from logger import logger
from base_agent import AgentState
from security.secure_jwt_manager import SecureJWTManager
from security.rbac_manager import RBACManager
from database import get_db_session # get_redis_client is mocked here for now
from auth import User, UserCreate, UserLogin
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Annotated
from fastapi import Depends, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import jwt
# import aioredis # Commented out due to conflict

# Initialize Security Components (Assuming Redis client is available)
# We will initialize Redis client in lifespan and pass it
redis_client: MockRedis = None
jwt_manager: SecureJWTManager = None
rbac_manager: RBACManager = RBACManager()

# Mock Redis for now
class MockRedis:
    async def close(self):
        pass
    async def get(self, key):
        return None
    async def set(self, key, value, ex):
        pass

async def get_redis_client():
    return MockRedis()



# OAuth2 scheme for token retrieval
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.api_prefix}/auth/login")

async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: Annotated[AsyncSession, Depends(get_db_session)]) -> User:
    try:
        payload = jwt_manager.decode_token(token)
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")
        
        # In a real app, fetch user from DB to ensure active status
        # For now, we'll assume the token is enough
        # user = await db.get(User, user_id)
        # if user is None:
        #     raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
        
        # Basic mock user for demonstration
        mock_user = User(id=int(user_id), username=f"user_{user_id}", email=f"user{user_id}@ymera.com", role="admin")
        return mock_user
    except jwt.PyJWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Could not validate credentials", headers={"WWW-Authenticate": "Bearer"})

async def get_admin_user(current_user: Annotated[User, Depends(get_current_user)]):
    if not rbac_manager.has_permission(current_user.role, "admin_access"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    return current_user



class ConnectionManager:
    """WebSocket connection manager"""
    
    def __init__(self):
        self.active_connections: List[WebSocket] = []
    
    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)
        logger.info(f"WebSocket client connected. Total: {len(self.active_connections)}")
    
    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)
        logger.info(f"WebSocket client disconnected. Total: {len(self.active_connections)}")
    
    async def broadcast(self, message: dict):
        """Broadcast message to all connected clients"""
        message_str = json.dumps(message)
        for connection in self.active_connections:
            try:
                await connection.send_text(message_str)
            except Exception as e:
                logger.error(f"Error broadcasting to client: {e}")


manager = ConnectionManager()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager"""
    # Startup
    logger.info(f"Starting {settings.app_name} v{settings.app_version}")
    await init_db()
    
    # Initialize JWT Manager
    global jwt_manager
    jwt_manager = SecureJWTManager(
        redis_client=await get_redis_client(),
        secret_or_private_key=settings.secret_key,
        algorithm=settings.algorithm
    )
    logger.info("Database initialized")
    
    yield
    
    # Shutdown
    logger.info("Shutting down application")
    await close_db()
    logger.info("Database connections closed")


app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    lifespan=lifespan,
    docs_url=f"{settings.api_prefix}/docs",
    redoc_url=f"{settings.api_prefix}/redoc",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- New Authentication Routes ---

@app.post(f"{settings.api_prefix}/auth/register", response_model=User)
async def register_user(user_data: UserCreate, db: Annotated[AsyncSession, Depends(get_db_session)]):
    # This is a placeholder for actual registration logic
    # In a real app, hash password and save to DB
    new_user = User(id=1, username=user_data.username, email=user_data.email, role="user")
    return new_user

@app.post(f"{settings.api_prefix}/auth/login")
async def login_for_access_token(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[AsyncSession, Depends(get_db_session)]):
    # This is a placeholder for actual login logic (e.g., verify password hash)
    if form_data.username != "admin" or form_data.password != "password":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")
    
    # Mock user ID for token
    user_id = 1 
    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = await jwt_manager.create_token(
        payload={"sub": str(user_id), "role": "admin"}, 
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@app.post(f"{settings.api_prefix}/auth/logout")
async def logout_user(current_user: Annotated[User, Depends(get_current_user)]):
    # Revoke the current token (requires token to be passed in header)
    # This is a placeholder for actual revocation logic
    return {"message": "Successfully logged out"}
    
# --- End New Authentication Routes ---


@app.get("/")
async def root() -> Dict[str, str]:
    """Root endpoint"""
    return {
        "name": settings.app_name,
        "version": settings.app_version,
        "status": "running"
    }


@app.get(f"{settings.api_prefix}/health")
async def health_check() -> Dict[str, Any]:
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": settings.app_name,
        "version": settings.app_version,
        "environment": settings.environment
    }


@app.get(f"{settings.api_prefix}/system/info")
async def system_info() -> Dict[str, Any]:
    """System information endpoint"""
    return {
        "name": settings.app_name,
        "version": settings.app_version,
        "environment": settings.environment,
        "websocket_connections": len(manager.active_connections)
    }


@app.get(f"{settings.api_prefix}/agents")
async def list_agents(current_user: Annotated[User, Depends(get_current_user)]) -> Dict[str, Any]:
    """List all agents"""
    # This would query the database for active agents
    return {
        "success": True,
        "data": {
            "agents": [],
            "pagination": {
                "page": 1,
                "limit": 20,
                "total": 0,
                "pages": 0
            }
        }
    }


@app.post(f"{settings.api_prefix}/agents")
async def create_agent(agent_data: Dict[str, Any], current_user: Annotated[User, Depends(get_admin_user)]) -> Dict[str, Any]:
    """Create a new agent"""
    # This would create a new agent instance
    agent_id = agent_data.get("agent_id")
    if not agent_id:
        raise HTTPException(status_code=400, detail="agent_id is required")
    
    # Broadcast agent creation event
    await manager.broadcast({
        "event": "agent:created",
        "data": {
            "id": agent_id,
            "name": agent_data.get("name", "New Agent"),
            "type": agent_data.get("type", "coder")
        }
    })
    
    return {
        "success": True,
        "data": {
            "id": agent_id,
            "status": "created"
        }
    }


@app.get(f"{settings.api_prefix}/agents/{{agent_id}}")
async def get_agent(agent_id: str, current_user: Annotated[User, Depends(get_current_user)]) -> Dict[str, Any]:
    """Get agent details"""
    # This would query the database for the specific agent
    return {
        "success": True,
        "data": {
            "id": agent_id,
            "name": f"Agent {agent_id}",
            "type": "coder",
            "status": "active",
            "state": AgentState.INITIALIZED.value,
            "description": "AI Agent",
            "capabilities": ["code_generation", "debugging"],
            "metrics": {
                "tasksCompleted": 0,
                "successRate": 0.0,
                "avgExecutionTime": 0
            }
        }
    }


@app.delete(f"{settings.api_prefix}/agents/{{agent_id}}")
async def delete_agent(agent_id: str, current_user: Annotated[User, Depends(get_admin_user)]) -> Dict[str, Any]:
    """Delete an agent"""
    # This would stop and remove the agent
    
    # Broadcast agent deletion event
    await manager.broadcast({
        "event": "agent:deleted",
        "data": {
            "id": agent_id
        }
    })
    
    return {
        "success": True,
        "message": "Agent deleted successfully"
    }


@app.get(f"{settings.api_prefix}/projects")
async def list_projects(current_user: Annotated[User, Depends(get_current_user)]) -> Dict[str, Any]:
    """List all projects"""
    return {
        "success": True,
        "data": {
            "projects": []
        }
    }


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket, current_user: Annotated[User, Depends(get_current_user)]):
    """WebSocket endpoint for real-time communication"""
    await manager.connect(websocket)
    try:
        while True:
            # Receive message from client
            data = await websocket.receive_text()
            message = json.loads(data)
            
            # Handle different message types
            if message.get("type") == "ping":
                await websocket.send_text(json.dumps({"type": "pong"}))
            elif message.get("type") == "subscribe":
                channel = message.get("channel")
                logger.info(f"Client subscribed to channel: {channel}")
                await websocket.send_text(json.dumps({
                    "type": "subscribed",
                    "channel": channel
                }))
            else:
                # Echo back for now
                await websocket.send_text(json.dumps({
                    "type": "message",
                    "data": message
                }))
    except WebSocketDisconnect:
        manager.disconnect(websocket)
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
        manager.disconnect(websocket)


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.debug,
        log_level=settings.log_level.lower(),
    )
