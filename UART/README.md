# Project UART
UART stands for **"Universal Asynchronous Receiver-Transmitter"**. UART System is an Asynchronous and Full Duplex communication protocol, which is typically used for inter chip communication purposes.

An instance of UART in an system have an Transmitter TX and Reciver RX modules, which are connected using single wire each. The involved chips may have diffirent clock frequency and may have different phase - relying on agreed Baud Rate (i.e. bit rate when working with bits), Start Bit and Over Sampling to maintain effective transfer and capture link(s).

## Milestones
- [x] Tx Fractional Baud Rate Generator (Run on demand)
- [ ] Tx FSM (Parameterised packet size)
- [ ] Tx Module ()
- [ ] Rx Fractional Baud Rate Generator (Run on demand & half baud cycle signaling)
- [ ] Rx FSM (Follow Tx parameters)
- [ ] Rx Module 
- [ ] Tx FIFO (with parity generation)
- [ ] Rx FIFO (with parity verification)

