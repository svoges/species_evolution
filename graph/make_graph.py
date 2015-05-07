import numpy as np
import matplotlib.pyplot as plt

# Average fitness levels
with open("output/average.txt") as f:
    data = f.read()

data = data.split('\n')
data.remove('')

x = [row.split(' ')[0] for row in data]
y = [row.split(' ')[1] for row in data]

fig = plt.figure()

ax1 = fig.add_subplot(111)

ax1.set_title("Average Energy Level per Generation")
ax1.set_xlabel('Generation')
ax1.set_ylabel('Energy Level')

ax1.plot(x,y, c='r', label='energy level')

leg = ax1.legend()

plt.show()

# Best fitness levels
with open("output/best.txt") as f:
    data = f.read()

data = data.split('\n')
data.remove('')

x = [row.split(' ')[0] for row in data]
y = [row.split(' ')[1] for row in data]

fig = plt.figure()

ax1 = fig.add_subplot(111)

ax1.set_title("Best Person per Generation")
ax1.set_xlabel('Generation')
ax1.set_ylabel('Energy Level')

ax1.plot(x,y, c='r', label='energy level')

leg = ax1.legend()

plt.show()

# Number of survivors
with open("output/survivors.txt") as f:
    data = f.read()

data = data.split('\n')
data.remove('')

x = [row.split(' ')[0] for row in data]
y = [row.split(' ')[1] for row in data]

fig = plt.figure()

ax1 = fig.add_subplot(111)

ax1.set_title("Survivors per Generation")
ax1.set_xlabel('Generation')
ax1.set_ylabel('Number of Survivors')

ax1.plot(x,y, c='r', label='survivors')

leg = ax1.legend()

plt.show()
