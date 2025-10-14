from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI()

# Endpoint Health Check
@app.get("/health", status_code=200)
async def health_check():
    """Endpoint for health check."""
    return JSONResponse(content={"status": "ok"})

# Endpoint Welcome Message
@app.get("/", status_code=200)
async def welcome():
    """Endpoint for Welcome"""
    return JSONResponse(content={"message": "Welcome from the Python FastAPI service!"})

# Entry point
if __name__ == "__main__":
    import uvicorn
    # Sử dụng biến môi trường để lấy port, mặc định là 8000
    # FastAPI/Uvicorn thường chạy mặc định trên port 8000
    port = 8000 # Có thể dùng os.getenv("PORT", "8000")
    print(f"Python FastAPI service starting on port {port}...")
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)
