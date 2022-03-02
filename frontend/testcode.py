#!/bin/python3

#import requests, 
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-r", "--role", help="display role of current user", action='store_true')
args = parser.parse_args()
if args.role:
    print("Role now displays properly")
