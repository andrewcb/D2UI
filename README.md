D2UI
====

Code for the data-driven creation and positioning of iOS UI elements and layers, i.e., for visualisation


This is an XCode workspace containing D2UI, a small library for the data-driven automatic creation, removal and manipulation of Cocoa Touch UI elements and CoreAnimation layers, along with an iPhone/iPad example application showing its use in four types of display (two examples of bar charts, a dynamic X/Y display and pie charts). The pie chart example also includes a custom CALayer subclass which can draw animatable pie slices.

This is very much a proof of concept, and lacks the polish of a complete chart display solution; however, it can be used as a building block for building various kinds of data-driven visualisations and/or user interfaces. The initial impetus of this project was to experiment with how much of the philosophy of the [D3](http://d3js.org) JavaScript library could be replicated natively in Objective C using iOS components.  There is a blog post describing it [here](http://tech.null.org).

This project was created using XCode 5, and may or may not work with earlier versions.
