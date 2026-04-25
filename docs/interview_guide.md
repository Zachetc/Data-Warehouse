# Interview Guide

This project extends my CityPulse ETL pipeline. The ETL pipeline prepares cleaned service request records, while this warehouse reshapes those records into a star schema for reporting.

A simple explanation: raw records are hard to repeatedly analyze because dates, locations, statuses, and categories are mixed into one table. This warehouse separates those concepts into dimensions and connects them to a fact table so analysis is more consistent.
