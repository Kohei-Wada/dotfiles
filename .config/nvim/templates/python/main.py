#!/usr/bin/env python3
import sys


def main():
    argv = sys.argv
    if len(argv) > 1:
        print(f"Arguments received: {argv[1:]}")
    else:
        print("No arguments received.")


if __name__ == "__main__":
    main()
