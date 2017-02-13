#!/bin/bash

function blankscreen() {
	xset s on dpms force off
}

function noblankscreen() {
	xset s off -dpms
}

noblankscreen
