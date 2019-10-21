import sys
lines=[]

for line in sys.stdin:
    stripped = line.strip()
    if not stripped:break
    lines.append(stripped)

print(lines)
