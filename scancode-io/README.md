# ScanCode.io Project Runner

This directory contains a small Python script that creates projects and executes pipelines via the ScanCode.io API.

## Setup

1. Change to this directory:
    ```bash
    cd scancode-io
    ```

2. Install the dependencies:
    ```bash
    pip install -r requirements.txt
    
    # or start a nix shell
    nix-shell -p python311Packages.requests python311
    ```

3. Set your environment variables (for example using `export` on Linux/macOS or `set` on Windows). You can also use a `.env` file with `python-dotenv` if desired.
    ```bash
    export SCANCODEIO_URL=https://your-scancode-server
    export SCANCODEIO_API_KEY=your_api_token
    export PROJECT_NAME=example-project
    export INPUT_URLS=https://github.com/aboutcode-org/scancode.io/archive/refs/tags/v32.4.0.zip
    export PIPELINES=inspect_packages,find_vulnerabilities
    export EXECUTE_NOW=true

    # or create your own .env file an load variables with:
    export $(grep -v '^#' .env | xargs)
    ```

4. Run the script:
    ```bash
    python scan_project.py
    ```

## Security

- Always keep sensitive values such as tokens or server URLs out of your repository.  
- Use secure methods such as environment variables, CI/CD secrets, or vault services to manage secrets.

## CI/CD with GitHub Actions

This repository comes with a GitHub Actions workflow under `.github/workflows/scancode-io.yml` that runs the script automatically on every push to `main` or manually via the GitHub Actions UI.

## License

MIT License
