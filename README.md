# README

## HISTORICAL BACKGROUND

The original idea for this project started back in 2013.  It is provided as a community resource, for didactical reasons.  Possibly, it could be useful to the participating universities in the then “professional improvement program” institutions from the State of São Paulo, which might still access the now “legacy” application, to review historical data from the students.  

That is to say, this repository is a public version of the code for a system I designed and developed while at the São Paulo State Health Secretariat in Brazil. It used Rails as the web framework and Zurb foundation for the interface.  For completeness, may I also mention that this repository uses sample data and therefore does not include all the functionality and scripts present in the (then) production version.   

The feedback from users and the teams involved was generally very positive.  The production version was in Portuguese and had a different project name.  The codebase included various *rake tasks*, in addition to some other features related to Brazilian tax reporting requirements, for instance.  It ran from April 2016 and was successfully used during the 2016, 2017 and 2018 school years.  It was, quite possibly, the first system in the São Paulo State government to use Ruby on Rails technology.     

Sometime later, after my departure from the Secretariat in 2018, a PHP application was then put into production, after the database had been cloned.  As far as I know, it was developed by an external developer, from outside the very competent team I worked on, without formal training in computer science or engineering.             

## ABOUT

   I have revised and refactored some of the code for this international version.

   The latest update includes additional text in English, such as localized help tooltips ("balloons") in the contact form.

   Regarding the sample data (which may be loaded via *rake db:seed*), most of it is in Portuguese, such as states
   municipalities, countries, etc.  Street names are already in English, for the international version.

   *Institutions and people's names are purely fictional.*

### Matriculating students

The system allows participating institutions to matriculate students in a user friendly way, during the "registration season".

### Payroll

In addition, each month, local staff at institutions inform which (current) students have absences and other events in preparation for the month's "payroll".  Otherwise, it is assumed (for the sake of efficiency) that the scholarship recipient showed up everyday and thus would receive a full monthly stipend.

At the end of the payroll data entry period, program managers and administrative staff at "HQ" (i.e. the organization which manages the program and pays for the students) then proceed to verify the events recorded (which are initially marked as 'pending').  They also confirm any cancellations which may have occurred.  The system allows for attachments to be provided, which aid in this verification.

The payroll is assumed to range from the first to the last calendar day (on a particular month).

The system will generate a unique **annotation** for each student's registration, reflecting the one or more events which may have taken place during the month being analysed.  That is to say, students without events or registration changes (such as cancellations) will not be "annotated".  That is the most common case.

### User interface

The system uses a responsive user interface. Theoretically, it should work with various browsers and mobile devices.

## SAMPLE LOGINS

#### 1. System administrator (full access)

E-mail: **system-admin@example.com**

password: **samplepass**

#### 2. Program manager (wide ranging access inside its program area)

E-mail: **program-manager@example.com**

password: **samplepass**

#### 3. Local manager (sees local participating institution only)

E-mail: **dean@example.org**
password: **samplepass**

## TECHNICAL INFORMATION   

Originally developed using both Linux and Mac.  

#### Ruby: ruby 3.0.6p216 (2023-03-30 revision 23a532679b) [x86_64-linux]
#### Rails: 6.1.7.6
#### Database: Postgres 15.5

## Containerized version (development)

Refer to the 

[README_containers.md](README_containers.md) file for instructions.

---

## This page last updated

*25/JAN/2024*

---
## COPYRIGHT

Copyright © 2024 Marcelo Eduardo Redoschi

*Licensed under the GNU Affero General Public License v3.0*
