# frozen_string_literal: true

# Internationalized
named = 'definitions.role.names.'

Role.create!([
               { name: I18n.t(named + 'pap.clerical'), management: false, teaching: false, clerical: true, pap: true, medres: true, collaborator: false, student: false, itstaff: false },
               { name: I18n.t(named + 'pap.student'), management: false, teaching: false, clerical: false, pap: true, medres: false, collaborator: false, student: true, itstaff: false },
               { name: I18n.t(named + 'pap.collaborator'), management: false, teaching: false, clerical: false, pap: true, medres: false, collaborator: true, student: false, itstaff: false },
               { name: I18n.t(named + 'medres.collaborator'), management: false, teaching: false, clerical: false, pap: false, medres: true, collaborator: true, student: false, itstaff: false },
               { name: I18n.t(named + 'pap.localmanager'), management: true, teaching: false, clerical: false, pap: true, medres: true, collaborator: false, student: false, itstaff: false },
               { name: I18n.t(named + 'pap.localmanagersubstitute'), management: true, teaching: false, clerical: false, pap: true, medres: false, collaborator: false, student: false, itstaff: false },
               { name: I18n.t(named + 'pap.supervisor'), management: false, teaching: true, clerical: false, pap: true, medres: true, collaborator: false, student: false, itstaff: false },
               { name: I18n.t(named + 'medres.student'), management: false, teaching: false, clerical: false, pap: false, medres: true, collaborator: false, student: true, itstaff: false },
               { name: I18n.t(named + 'itstaff'), management: false, teaching: false, clerical: false, pap: false, medres: false, collaborator: false, student: false, itstaff: true }
             ])
