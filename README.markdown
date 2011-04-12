# App Opener

A Little App which takes a text file with questions and answers in and turns it into a timed, scored quiz.

# How the Quiz Works

For each question you have 10 second to answer, in these ten seconds a score slowly ticks downwards starting at `10000` and dropping `1000` every second.

If you answer correctly the score for that question will be added to your overall score. However, if you answer incorrectly or take too long you will get 0 points.

At the end of the Quiz you can review your overall score and see how well you did. If you want to see which specific questions you got wrong, a panel at the side allows you to see this. 

This type of quiz aims to show how your knowledge of a subject is and how quick your recall is.

# Creating your own Quiz

The formatting is simple:

Prefix the question with `Q:` like so:

    Q: What is the Capital of Australia?

Then without leaving any line spaces and just simply going onto new lines, type in the the possible answers which should each be prefixed with `A:` like so:

    A: Sydney
    A: Canberra
    A: Perth

To mark which answer is correct suffix the answer with `[CORRECT]` like so:

    A: Sydney
    A: Canberra [CORRECT]
    A: Perth

To start a new question leave a blank line in-between. If your not sure just look at the sample quiz provided.

# Screenshot

![Screen](http://idzr.org/0fec)