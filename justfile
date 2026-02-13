build:
    uv run build.py --output_dir '_site' --template 'templates/index.html.j2'

preview:
    python -m http.server -d _site

start page:
    marimo run {{ page }}
