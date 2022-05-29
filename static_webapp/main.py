from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import uvicorn

app = FastAPI(
    title="static"
)

app.mount(
    "/static",
    StaticFiles(directory="static_webapp/static"), 
    name="static"
)

@app.get("/", response_class=HTMLResponse)
def home():
    return """
        <html>
            <head>
            <link rel="stylesheet" href="./static/style.css">
            </head>
            <body>
                <img src="./static/logo.png" alt="Flugel logo" class="center">
            </body>
        </html>
    """


@app.get("/health", status_code=200)
async def root():
    return {"status": "Healthy"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)