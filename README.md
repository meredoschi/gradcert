# README

## HISTORICAL BACKGROUND

Back in 2013, I first started writing what would then become **grad**uate **cert**ificate.

It originated as a personal project and steadily grew (coded entirely by myself).  As I learned more about Ruby on Rails, I later wrote some Rspec tests and began to use linters to beautify the code, when feasible.

The production version (in Portuguese) has been running since April 2016 with generally very positive feedback from users.
During my stay at the São Paulo Health Department, I've regularly updated it for quality.  I tried and incorporated
some valuable suggestions and recommendations from users, business analysts and the management staff.

## ABOUT

   I am still in the process of revising and refactoring some of the code for this international version.

   This latest update includes additional text in English (i18n keys).  The translation is *almost* complete.

   So when run in the English locale (the default for the international version) some *translation missing* notices may still appear.


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

E-mail: **dean@state-u.org**
password: **samplepass**

## RUBY VERSION

2.3.5 (rvm)

Developed on both Linux and Mac environments.

## DATABASE

Postgres 9.6.7

## LAST UPDATED

*24/AUG/2018*

=======
## COPYRIGHT

Copyright © 2018 Marcelo Eduardo Redoschi

*Licensed under the GNU Affero General Public License v3.0*
