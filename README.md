

# Verification of an Industry-Standard I2C Controller using UVM

This project is a complete UVM testbench built from the ground up to verify a real-world **I2C (Inter-Integrated Circuit) Master-Slave Controller**.

A key aspect of this project is that the RTL code for the I2C controller is a proven, open-source design sourced from **OpenCores.org**. My objective was to develop reusable verification environment to validate this industry-standard IP.



---

### About the I2C Protocol

I2C is a popular two-wire serial protocol (SDA for data, SCL for clock) used for short-distance communication between integrated circuits, like a microcontroller and its peripheral sensors. It uses a master-slave architecture where the master initiates and controls all communication on the bus.

---

### The RTL Design (The DUT)

The Design Under Test (DUT) is the **I2C Master Controller core from OpenCores**. It's a sophisticated piece of hardware responsible for:
* Generating the precise timing for **START** and **STOP** conditions to manage the bus.
* Serializing data to be sent on the **SDA** line.
* Handling **Acknowledge (ACK)** and **Not Acknowledge (NACK)** bits to ensure data is received correctly.
* Communicating with an internal system bus (like Wishbone or APB) to get its commands.

---

### My Verification Strategy

I developed a comprehensive **UVM testbench from scratch** to fully exercise the I2C core.

* **1. The Agent**: The I2C core needs instructions, like "send this data to slave address 0x50." I built an active UVM agent that acts as a processor, sending these high-level commands to the controller via its internal bus.

* **2. The I2C Agent**: To test the master, you need a slave to talk to. I built a configurable I2C agent that can be programmed to act as one or more slave devices on the bus. It intelligently listens for its address and responds to the master's requests just like a real-world sensor or memory chip would.

* **3. The Scoreboard**: The scoreboard watches the high-level commands sent by the "Programmer" agent and compares them to the actual I2C transactions observed on the bus by the "Slave" agent's monitor. This ensures that the controller is correctly translating its instructions into the proper I2C protocol signals.

---

### Key Test Scenarios I Ran

My test suite covered a wide range of I2C operations to ensure the core is robust:

* **Basic Write/Read**: Verifying single-byte transfers to a specific slave.
* **Burst Write/Read**: Testing multi-byte (page) transfers.
* **ACK/NACK Handling**: Creating scenarios where a slave does not acknowledge (NACK) to verify the master's error-handling response.
* **Multi-Slave Communication**: Testing the master's ability to address and communicate with several different slaves on the same bus.
* **Repeated START**: Verifying the master can switch from a write to a read operation without releasing the bus.
