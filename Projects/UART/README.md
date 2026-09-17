# Project UART
UART stands for **"Universal Asynchronous Receiver-Transmitter"**. A simple instance of UART is an asynchronous simplex link - meaning that it communicates only in one direction, but is typically used in Full duplex configuration (in an system, using a pair of instance).

An instance of UART have an Transmitter TX and Reciver RX, which are connected using single wire. The RX and TX may be operated in diffirent clock frequency and may have different phase - But they use an standard baud rate and the RX should Over sample.



## Steps
-[ ] Counter 
-[ ] Binary to grey encoder 
-[ ] Baud rate generator 
-[ ] FIFO 
-[ ] Parallel to serial & Serial to parallel registers 
-[ ] 