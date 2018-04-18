# IrisRecognition

This project aimed at building a recognition system by using iris images of each subject. 
By comparing the matching score in this system to draw genuine and impostor distributions, ROC curves and CMC curves to identify a person.

We used the open source iris recognition software - Libor Masek's open source iris matching code to do the iris data extraction and matching scoring. And there are some MATLAB codes designed by ourselves:

-- irisExtractor.m
This is a MATLAB script to extract every iris data from images and store them in a “.mat” file.

-- model.m
This is a MATLAB script to build a model and plot a distribution of all templates in this model. This model contains multiple templates for each subject and each subject have two kinds of templates: left iris and right iris.

-- threshold_finder.m (optional)
This is a simple threshold finder code to find a threshold of the model, which minimizes the intersection of genuine distribution and imposter distribution. Note that this is not a requirement of this project.

-- matching.m
This is a MATLAB script to match the probes with the templates in our model. It generates scores for all positives and negatives and draws a distribution for each probe.

-- ROC_CMC.m
This is a plotting function to draw ROC curves and CMC curves for the matching scores of each probe.