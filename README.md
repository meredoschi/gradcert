# README

## HISTORICAL BACKGROUND

Back in 2013, I first started writing what would then become **grad**uate **cert**ificate.  It started as a personal project and steadily grew.  I've coded and installed the production version.

It ran from April 2016 and was successfully used during the 2016, 2017 and 2018 school years.

The feedback from users and the teams involved was generally very positive.  The production version used Portuguese as the default language and the codebase was slightly different.  It included the various *rake tasks* I wrote, in addition to some other features related to Brazilian tax reporting requirements, for instance.

*Since my departure from public service on April 2018, there have been two new administrations.*

*My expectation, as the architect/developer, in line with original project requirements, was that the system would be in place for many years to come.  Much to my surprise, however, I just recently learned that this was no longer the case.
Therefore, I thought it best to update this page accordingly, for the sake of completeness.*

*It was, as far as I know, the first system in São Paulo State government to use Ruby on Rails technology.*

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

*28/MAR/2019*

=======
## COPYRIGHT

Copyright © 2019 Marcelo Eduardo Redoschi

*Licensed under the GNU Affero General Public License v3.0*
