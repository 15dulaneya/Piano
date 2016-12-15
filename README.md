Introduction

For our final project, we wanted to be able to use the FPGA in combination with various peripherals to design a piano. Our piano takes input through the keyboard and outputs the corresponding frequencies out through the audio CODEC and displays the note being played on the VGA monitor. 

Design Description

Keyboard

The first part of the problem that we chose to tackle was getting communication from the PS2 keyboard to the Altera DE2 board. One helpful source for this problem was john loomis. We wanted to be able to display the note that the user is playing on the hex displays of the DE2 board. One issue that we ran into was that the note we played would not stop displaying once we let go of the corresponding key. In order to fix this problem we had to use the break codes sent from the keyboard to let the board know that the key is no longer being held down

VGA

Next, we needed to figure out how to display rectangles on the VGA so that we could show an interactive piano that would light up the key that was being played. We had edited code from ____ that we could use create and draw rectangles on the monitor. We then combined this module with the keyboard module so we could change what was being displayed based on what keys were being pressed. To achieve this we just applied cases for different keyboard make and break codes that would trigger which key should or should not be light up.

Audio

Lastly, and most importantly, we have to generate and output the audio equivalent to the user input. This portion of the project proved to be the biggest challenge. Our main source for figuring out how to generate sine waves was john loomis’ audio2 lab, and to generate the specific notes was ______. When we finally got the DE2 board to output the audio via the keyboard interactions, our VGA would not display anymore.

Conclusion

After completing this project, we learned that audio on the FPGA is harder than we thought it was going to be and that we are not as good at coding in Verilog as we thought either. We also learned how to use the peripherals of the DE2 board. Some improvements that we could make are implementing our octave and song buttons that we had mentioned in our report if we had extra time. Also, we could try adding the feature of being able to play multiple notes at once (be able to play chords). Finally, we could get a better grasp on John Loomis’ audio2 lab and ____ note_generation module so that we could fix some of the frequencies and sine waves in order to make the audio sound closer to the real notes on a piano.
