Access the main app by going to CSC 680 Public Transit folder and clicking on ContentView.swift 

This application so far has the Muni Arrival View, which can be accessed as the mock version of MuniArrivalsView.swift
It is to demonstrate how it is supposed to look when taking the Muni API and show the nearest Muni bus stop and arrival time, either based
on the user's location or where the user's pin is on the map. The actual application can be accessed on ContentView. It is at the bottom
middle section. If the user is bored waiting for the bus, they can play Blackjack, which is located at the bottom right section.

A Blackjack game or 21 can be viewed on BlackjackGameView.swift or the bottom left when accessing ContentView.swift for the user's experience on their iPhone. 

Screenshots consisting of:
1.ContentView shows the first page when the user opens the map. If the user turns off their location for this app for privacy, they could use the pin on the map to get to the nearest Muni bus stop.
2.ContentView shows the nearest Muni bus stop list, although the API does not work on Xcode. Please take a look at MuniArrivalsView.swift for the mock version.
3.ContentView shows a Blackjack game or 21.
4.MockMuniArrivalsView shows the mock version of what the user is supposed to see if choosing a location within San Francisco or where Muni runs to the nearest bus stop and the bus time arrival. 

Potential update to this application:
Plans were made to integrate Bay Area Rapid Transit or BART; thus, users can use the app throughout the San Francisco Bay Area. Also, when clicking the desired station on the arrival view, a route to the station. If the user is too far from the station to arrive before the bus, a highlighted next bus arrival time would appear to tell the user to give it up. Chill and wait for the next one. If they somehow made it, they should be rewarded with a sticker and the message "GOOD JOB, WOW YOU MUST BE SWEATING!" and there is an option for the user to reply with "Yeah, I'm sweating like a pig!" or "NO SWEAT NO SWEAT, THAT WAS MY 10%!" 

Purpose of this application:
This application was created to allow users to see the closest bus stops and know when the bus arrives, allowing them to run or take their time to walk to their station. 
