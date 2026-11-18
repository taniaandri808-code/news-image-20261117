import os
import sys

def main():
    # Path to the image produced by build.py (same directory)
    src_path = os.path.join(os.path.dirname(__file__), "entry.png")
    # Destination directory from env var or default /output
    out_dir = os.getenv("MAKEFUN_OUTPUT_DIR", "/output")
    os.makedirs(out_dir, exist_ok=True)
    dst_path = os.path.join(out_dir, "entry.png")
    # Copy bytes
    with open(src_path, "rb") as src, open(dst_path, "wb") as dst:
        dst.write(src.read())

if __name__ == "__main__":
    main()
