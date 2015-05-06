import numpy as np
import matplotlib.pyplot as plt

with open("output/output.txt") as f:
    data = f.read()

data = data.split('\n')
data.remove('')

x = [row.split(' ')[0] for row in data]
y = [row.split(' ')[1] for row in data]

fig = plt.figure()

ax1 = fig.add_subplot(111)

ax1.set_title("Energy Level per Generation")
ax1.set_xlabel('Generation')
ax1.set_ylabel('Energy Level')

ax1.plot(x,y, c='r', label='energy level')

leg = ax1.legend()

plt.show()
