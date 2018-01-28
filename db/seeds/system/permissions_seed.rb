# Internationalized
desc = 'definitions.user_permission.description.'

Permission.create!([
                     { kind: 'admin', description: I18n.t(desc + 'admin') },
                     { kind: 'pap', description: I18n.t(desc + 'admin') },
                     { kind: 'medreslocaladm', description: I18n.t(desc + 'medreslocaladm') },
                     { kind: 'papcollaborator', description: I18n.t(desc + 'papcollaborator') },
                     { kind: 'medrescollaborator', description: I18n.t(desc + 'medrescollaborator') },
                     { kind: 'paplocaladm', description: I18n.t(desc + 'paplocaladm') },
                     { kind: 'medresmgr', description: I18n.t(desc + 'medresmgr') },
                     { kind: 'papmgr', description: I18n.t(desc + 'papmgr') },
                     { kind: 'medres', description: I18n.t(desc + 'medres') },
                     { kind: 'adminreadonly', description: I18n.t(desc + 'adminreadonly') }
                   ])
