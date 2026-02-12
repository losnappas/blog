# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "marimo",
# ]
# ///

import marimo

__generated_with = "0.8.19"
app = marimo.App(width="full")

with app.setup:
    import marimo as mo

@app.cell(hide_code=True)
def __():
    mo.md("""# Welcome to marimo!""")
    return



if __name__ == "__main__":
    app.run()
