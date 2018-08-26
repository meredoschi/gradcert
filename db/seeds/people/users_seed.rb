# frozen_string_literal: true

User.create!([
               { email: 'system-admin@example.com', password: 'samplepass', password_confirmation: 'samplepass', institution_id: 1, permission_id: 1 },
               { email: 'program-manager@example.com', password: 'samplepass', password_confirmation: 'samplepass', institution_id: 1, permission_id: 8 },
               { email: 'dean@state-u.org', password: 'samplepass', password_confirmation: 'samplepass', institution_id: 2, permission_id: 6 }

             ])
