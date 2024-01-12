# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_13_174039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academiccategories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_academiccategories_on_name", unique: true
  end

  create_table "accreditations", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.date "start"
    t.date "renewal"
    t.boolean "revoked"
    t.date "revocation"
    t.string "comment", limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "suspension"
    t.boolean "suspended"
    t.boolean "original", default: false
    t.boolean "renewed", default: false
    t.integer "program_id"
    t.integer "registration_id"
    t.boolean "confirmed", default: false
    t.index ["institution_id"], name: "index_accreditations_on_institution_id", unique: true
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "streetname_id"
    t.string "addr", limit: 200
    t.string "complement", limit: 50
    t.string "neighborhood", limit: 50
    t.integer "municipality_id"
    t.string "postalcode", limit: 25
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "institution_id"
    t.integer "country_id"
    t.integer "contact_id"
    t.integer "regionaloffice_id"
    t.integer "program_id"
    t.string "header", limit: 120
    t.integer "course_id"
    t.boolean "internal", default: false
    t.integer "council_id"
    t.integer "streetnum"
    t.integer "bankbranch_id"
    t.index ["contact_id", "institution_id"], name: "index_addresses_on_contact_id_and_institution_id"
    t.index ["municipality_id"], name: "index_addresses_on_municipality_id"
  end

  create_table "admissions", id: :serial, force: :cascade do |t|
    t.date "start"
    t.date "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "program_id", null: false
    t.integer "grantsasked", default: 0, null: false
    t.integer "grantsgiven", default: 0, null: false
    t.integer "accreditedgrants", default: 0, null: false
    t.integer "appealsgrantedfinalexam", default: 0, null: false
    t.integer "appealsdeniedfinalexam", default: 0, null: false
    t.integer "candidates", default: 0, null: false
    t.integer "absentfirstexam", default: 0, null: false
    t.integer "absentfinalexam", default: 0, null: false
    t.integer "passedfirstexam", default: 0, null: false
    t.integer "appealsdeniedfirstexam", default: 0, null: false
    t.integer "appealsgrantedfirstexam", default: 0, null: false
    t.integer "admitted", default: 0, null: false
    t.integer "convoked", default: 0, null: false
    t.integer "insufficientfinalexamgrade", default: 0, null: false
  end

  create_table "annotations", id: :serial, force: :cascade do |t|
    t.integer "registration_id", null: false
    t.integer "payroll_id", null: false
    t.integer "absences"
    t.integer "discount_cents"
    t.boolean "skip", default: false
    t.string "comment", limit: 150
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "supplement_cents"
    t.boolean "confirmed", default: false
    t.boolean "automatic", default: false
    t.index ["registration_id", "payroll_id"], name: "index_annotations_on_registration_id_and_payroll_id"
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "program_id"
    t.integer "profession_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["program_id", "contact_id"], name: "index_assessments_on_program_id_and_contact_id"
  end

  create_table "assignments", id: :serial, force: :cascade do |t|
    t.integer "program_id"
    t.integer "supervisor_id"
    t.date "start_date"
    t.boolean "main", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["program_id", "supervisor_id"], name: "index_assignments_on_program_id_and_supervisor_id"
  end

  create_table "bankaccounts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.integer "bankbranch_id"
    t.string "num", limit: 10
    t.string "verificationdigit", limit: 10
  end

  create_table "bankbranches", id: :serial, force: :cascade do |t|
    t.string "code", limit: 5
    t.string "name", limit: 100
    t.string "formername", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verificationdigit", limit: 1
    t.date "opened"
    t.integer "address_id"
    t.integer "phone_id"
    t.integer "numericalcode"
  end

  create_table "bankpayments", id: :serial, force: :cascade do |t|
    t.integer "payroll_id"
    t.string "comment", limit: 150
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sequential"
    t.boolean "prepared", default: false
    t.integer "totalamount_cents", default: 0
    t.boolean "done", default: false
    t.boolean "resend", default: false
    t.boolean "statements", default: false
    t.index ["payroll_id"], name: "index_bankpayments_on_payroll_id"
  end

  create_table "brackets", id: :serial, force: :cascade do |t|
    t.integer "num"
    t.integer "start_cents"
    t.integer "finish_cents"
    t.boolean "unlimited", default: false
    t.integer "taxation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate", precision: 5, scale: 2, default: "0.0"
    t.integer "deductible_cents", default: 0
  end

  create_table "characteristics", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.string "mission", limit: 800
    t.string "corevalues", limit: 800
    t.string "userprofile", limit: 800
    t.integer "stateregion_id"
    t.string "relationwithpublichealthcare", limit: 800
    t.string "highlightareas", limit: 800
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["institution_id"], name: "index_characteristics_on_institution_id", unique: true
  end

  create_table "colleges", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "area"
    t.integer "classrooms"
    t.integer "otherrooms"
    t.integer "sportscourts"
    t.integer "foodplaces"
    t.integer "libraries"
    t.integer "gradcertificatecourses"
    t.integer "previousyeargradcertcompletions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["institution_id"], name: "index_colleges_on_institution_id", unique: true
  end

  create_table "completions", id: :serial, force: :cascade do |t|
    t.integer "registration_id"
    t.boolean "inprogress"
    t.boolean "pass"
    t.boolean "failure"
    t.boolean "mustmakeup"
    t.boolean "dnf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_completions_on_registration_id", unique: true
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id"
    t.date "termstart"
    t.date "termfinish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 200, null: false
    t.string "image"
    t.integer "address_id"
    t.integer "phone_id"
    t.integer "webinfo_id"
    t.integer "personalinfo_id"
    t.boolean "confirmed", default: false
    t.index ["role_id"], name: "index_contacts_on_role_id"
    t.index ["user_id"], name: "index_contacts_on_user_id", unique: true
  end

  create_table "councils", id: :serial, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.integer "address_id"
    t.integer "phone_id"
    t.integer "webinfo_id"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation", limit: 20
    t.index ["name", "state_id"], name: "index_councils_on_name_and_state_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "brname", limit: 70, null: false
    t.string "name", limit: 70, null: false
    t.string "a2", limit: 2
    t.string "a3", limit: 3
    t.integer "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "coursenames", id: :serial, force: :cascade do |t|
    t.string "name", limit: 200
    t.boolean "active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "previousname", limit: 100
    t.integer "legacycode"
    t.integer "school_id"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.index ["name"], name: "index_coursenames_on_name", unique: true
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.integer "coursename_id"
    t.integer "professionalfamily_id"
    t.boolean "practical", default: false
    t.boolean "core", default: false
    t.boolean "professionalrequirement", default: false
    t.integer "supervisor_id"
    t.integer "methodology_id"
    t.integer "address_id"
    t.integer "workload"
    t.string "syllabus", limit: 4000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "program_id"
  end

  create_table "degreetypes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "level"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "diplomas", id: :serial, force: :cascade do |t|
    t.integer "profession_id"
    t.integer "institution_id"
    t.string "externalinstitution"
    t.date "awarded"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "supervisor_id"
    t.integer "degreetype_id"
    t.boolean "ongoing", default: false
    t.integer "student_id"
    t.integer "schoolname_id"
    t.integer "coursename_id"
    t.integer "council_id"
    t.string "councilcredential", limit: 30
    t.integer "school_id"
    t.string "othercourse", limit: 100
    t.string "councilcredentialstatus", limit: 30
    t.date "councilcredentialexpiration"
    t.index ["degreetype_id"], name: "index_diplomas_on_degreetype_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.date "start"
    t.date "finish"
    t.integer "leavetype_id"
    t.boolean "absence", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "registration_id"
    t.integer "daystarted", default: 0
    t.integer "dayfinished", default: 0
    t.integer "annotation_id"
    t.boolean "residual", default: false
    t.boolean "confirmed", default: false
    t.boolean "processed", default: false
    t.string "supportingdocumentation"
    t.index ["registration_id", "start"], name: "index_events_on_registration_id_and_start"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.integer "registration_id"
    t.date "processingdate"
    t.boolean "approved", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payroll_id"
    t.boolean "processed", default: true
    t.integer "bankpayment_id"
    t.string "comment", limit: 200
  end

  create_table "fundings", id: :serial, force: :cascade do |t|
    t.integer "government"
    t.integer "agreements"
    t.integer "privatesector"
    t.integer "other"
    t.integer "ppp"
    t.boolean "percentvalues", default: false
    t.string "comment", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "characteristic_id", null: false
    t.index ["characteristic_id"], name: "index_fundings_on_characteristic_id"
  end

  create_table "healthcareinfos", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "totalbeds"
    t.integer "icubeds"
    t.integer "ambulatoryrooms"
    t.integer "labs"
    t.integer "emergencyroombeds"
    t.string "equipmenthighlights", limit: 800
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "consultations"
    t.integer "admissions"
    t.integer "radiologyprocedures"
    t.integer "labexams"
    t.integer "surgeries"
    t.index ["institution_id"], name: "index_healthcareinfos_on_institution_id", unique: true
  end

  create_table "institutions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 250, null: false
    t.integer "institutiontype_id"
    t.boolean "provisional", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sector", limit: 40
    t.integer "address_id"
    t.integer "phone_id"
    t.integer "webinfo_id"
    t.integer "accreditation_id"
    t.boolean "undergraduate", default: false
    t.integer "legacycode"
    t.string "abbreviation", limit: 20
    t.index ["name"], name: "index_institutions_on_name", unique: true
  end

  create_table "institutiontypes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 70, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_institutiontypes_on_name", unique: true
  end

  create_table "leavetypes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.boolean "paid", default: false
    t.string "comment", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "setnumdays"
    t.integer "dayspaidcap"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.integer "maxnumdays", default: 731
    t.boolean "vacation", default: false
    t.index ["name"], name: "index_leavetypes_on_name", unique: true
  end

  create_table "makeupschedules", id: :serial, force: :cascade do |t|
    t.date "start"
    t.date "finish"
    t.integer "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_makeupschedules_on_registration_id", unique: true
  end

  create_table "methodologies", id: :serial, force: :cascade do |t|
    t.string "kind", limit: 120
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["kind"], name: "index_methodologies_on_kind", unique: true
  end

  create_table "municipalities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.integer "stateregion_id"
    t.integer "codmuni"
    t.boolean "capital", default: false
    t.integer "regionaloffice_id"
    t.string "asciiname", limit: 50
    t.string "namewithstate"
    t.string "asciinamewithstate"
    t.index ["asciinamewithstate"], name: "index_municipalities_on_asciinamewithstate", unique: true
    t.index ["name", "stateregion_id"], name: "index_municipalities_on_name_and_stateregion_id", unique: true
    t.index ["namewithstate"], name: "index_municipalities_on_namewithstate", unique: true
  end

  create_table "payrolls", id: :serial, force: :cascade do |t|
    t.date "paymentdate", null: false
    t.string "comment", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_cents", default: 0, null: false
    t.integer "taxation_id"
    t.date "monthworked"
    t.integer "scholarship_id"
    t.boolean "special", default: false
    t.integer "daystarted", default: 0
    t.integer "dayfinished", default: 0
    t.boolean "annotated", default: false
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.datetime "dataentrystart"
    t.datetime "dataentryfinish"
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.string "kind", limit: 50, null: false
    t.string "description", limit: 150
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalinfos", id: :serial, force: :cascade do |t|
    t.string "sex", limit: 1
    t.string "gender", limit: 1
    t.date "dob"
    t.string "idtype", limit: 40
    t.string "idnumber", limit: 20
    t.integer "state_id"
    t.integer "country_id"
    t.string "socialsecuritynumber", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tin", limit: 20
    t.string "othername", limit: 30
    t.integer "contact_id"
    t.string "mothersname", limit: 100
    t.index ["contact_id"], name: "index_personalinfos_on_contact_id", unique: true
    t.index ["tin"], name: "index_personalinfos_on_tin"
  end

  create_table "phones", id: :serial, force: :cascade do |t|
    t.string "main", limit: 30
    t.string "mobile", limit: 30
    t.string "other", limit: 30
    t.integer "contact_id"
    t.integer "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "regionaloffice_id"
    t.integer "council_id"
    t.string "fax", limit: 20
    t.integer "bankbranch_id"
    t.index ["contact_id", "institution_id"], name: "index_phones_on_contact_id_and_institution_id"
  end

  create_table "placesavailables", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "schoolterm_id"
    t.integer "requested"
    t.integer "accredited"
    t.integer "authorized"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allowregistrations", default: false
  end

  create_table "professionalareas", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "previouscode", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "previousname", limit: 150
    t.string "comment", limit: 250
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.boolean "legacy", default: false
  end

  create_table "professionalfamilies", id: :serial, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.integer "subgroup_id"
    t.integer "familycode"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "council_id"
  end

  create_table "professionalspecialties", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "previouscode", limit: 10
    t.integer "professionalarea_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "previousname", limit: 150
    t.string "comment", limit: 250
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.boolean "legacy", default: false
  end

  create_table "professions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.integer "occupationcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "professionalfamily_id"
    t.string "asciiname", limit: 150
    t.index ["name"], name: "index_professions_on_name", unique: true
  end

  create_table "programnames", id: :serial, force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.boolean "active", default: true
    t.string "previousname", limit: 200
    t.string "comment", limit: 200
    t.boolean "legacy", default: false
    t.integer "ancestor_id"
    t.boolean "gradcert", default: false
    t.index ["name"], name: "index_programnames_on_name", unique: true
  end

  create_table "programs", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "programname_id"
    t.integer "duration"
    t.string "comment", limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.integer "address_id"
    t.boolean "internal", default: true
    t.integer "accreditation_id"
    t.integer "admission_id"
    t.integer "schoolterm_id"
    t.integer "professionalspecialty_id"
    t.string "previouscode", limit: 8
    t.integer "parentid"
    t.boolean "gradcert", default: false
    t.index ["institution_id", "programname_id"], name: "index_programs_on_institution_id_and_programname_id"
    t.index ["programname_id", "institution_id", "schoolterm_id"], name: "index_programs_on_name_inst_schoolterm", unique: true
  end

  create_table "programsituations", id: :serial, force: :cascade do |t|
    t.integer "assessment_id"
    t.integer "recommended_duration"
    t.string "goals", limit: 3000
    t.string "kind", limit: 3000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "favorable", default: false
    t.index ["assessment_id"], name: "index_programsituations_on_assessment_id", unique: true
  end

  create_table "recommendations", id: :serial, force: :cascade do |t|
    t.integer "programsituation_id"
    t.integer "grants"
    t.integer "theory"
    t.integer "practice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "programyear"
  end

  create_table "regionaloffices", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "num"
    t.integer "address_id"
    t.integer "phone_id"
    t.integer "webinfo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "directorsname", limit: 120, null: false
    t.index ["address_id"], name: "index_regionaloffices_on_address_id"
    t.index ["phone_id"], name: "index_regionaloffices_on_phone_id"
    t.index ["webinfo_id"], name: "index_regionaloffices_on_webinfo_id"
  end

  create_table "registrationkinds", id: :serial, force: :cascade do |t|
    t.boolean "regular", default: true
    t.boolean "makeup", default: false
    t.boolean "repeat", default: false
    t.boolean "veteran", default: false
    t.integer "previousregistrationid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "registration_id"
    t.index ["registration_id"], name: "index_registrationkinds_on_registration_id", unique: true
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "student_id"
    t.integer "schoolyear_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment", limit: 150
    t.integer "accreditation_id"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.boolean "returned", default: false
    t.float "finalgrade", default: 0.0
    t.integer "completion_id"
    t.integer "registrationkind_id"
    t.index ["student_id", "schoolyear_id"], name: "index_registrations_on_student_id_and_schoolyear_id", unique: true
  end

  create_table "researchcenters", id: :serial, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "rooms"
    t.integer "labs"
    t.integer "intlprojectsdone"
    t.integer "ongoingintlprojects"
    t.integer "domesticprojectsdone"
    t.integer "ongoingdomesticprojects"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["institution_id"], name: "index_researchcenters_on_institution_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 120, null: false
    t.boolean "management", default: false
    t.boolean "teaching", default: false
    t.boolean "clerical", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "pap"
    t.boolean "medres"
    t.boolean "collaborator", default: false
    t.boolean "student", default: false
    t.boolean "itstaff", default: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "rosters", id: :serial, force: :cascade do |t|
    t.integer "institution_id", null: false
    t.integer "schoolterm_id", null: false
    t.integer "authorizedsupervisors", default: 0
    t.datetime "dataentrystart", null: false
    t.datetime "dataentryfinish", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id", "schoolterm_id"], name: "index_rosters_on_institution_id_and_schoolterm_id", unique: true
  end

  create_table "scholarships", id: :serial, force: :cascade do |t|
    t.integer "amount_cents", default: 0
    t.date "start"
    t.date "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.string "comment", limit: 150
    t.integer "partialamount_cents", default: 0
    t.string "name", limit: 100
    t.integer "daystarted", default: 0
    t.integer "dayfinished", default: 0
    t.string "writtenform", limit: 200
    t.string "writtenformpartial", limit: 200
  end

  create_table "schoolnames", id: :serial, force: :cascade do |t|
    t.string "name", limit: 200
    t.string "previousname", limit: 200
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", id: :serial, force: :cascade do |t|
    t.string "name", limit: 120
    t.string "abbreviation", limit: 25
    t.integer "ministrycode"
    t.integer "academiccategory_id"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ministrycode"], name: "index_schools_on_ministrycode", unique: true
  end

  create_table "schoolterms", id: :serial, force: :cascade do |t|
    t.date "start", null: false
    t.date "finish", null: false
    t.boolean "pap", default: false
    t.boolean "medres", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "registrationseason", default: false
    t.integer "scholarshipsoffered", default: 0
    t.datetime "seasondebut"
    t.datetime "seasonclosure"
    t.datetime "admissionsdebut"
    t.datetime "admissionsclosure"
  end

  create_table "schooltypes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 70
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_schooltypes_on_name", unique: true
  end

  create_table "schoolyears", id: :serial, force: :cascade do |t|
    t.integer "programyear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "program_id"
    t.integer "pass"
    t.integer "theory", default: 0
    t.integer "practice", default: 0
  end

  create_table "statements", id: :serial, force: :cascade do |t|
    t.integer "registration_id"
    t.integer "grossamount_cents"
    t.integer "incometax_cents"
    t.integer "socialsecurity_cents"
    t.integer "childsupport_cents"
    t.integer "netamount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bankpayment_id"
    t.index ["registration_id", "bankpayment_id"], name: "index_statements_on_registration_id_and_bankpayment_id", unique: true
  end

  create_table "stateregions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 70, null: false
    t.integer "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["state_id", "name"], name: "index_stateregions_on_state_id_and_name"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name", limit: 80, null: false
    t.string "abbreviation", limit: 10
    t.integer "country_id"
    t.index ["name"], name: "index_states_on_name", unique: true
  end

  create_table "streetnames", id: :serial, force: :cascade do |t|
    t.string "designation", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["designation"], name: "index_streetnames_on_designation", unique: true
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "profession_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bankaccount_id"
    t.bigint "previouscode"
    t.integer "schoolterm_id"
    t.boolean "previousparticipant", default: false
    t.boolean "nationalhealthcareworker", default: false
    t.index ["bankaccount_id"], name: "index_students_on_bankaccount_id", unique: true
    t.index ["contact_id"], name: "index_students_on_contact_id"
    t.index ["schoolterm_id"], name: "index_students_on_schoolterm_id"
  end

  create_table "supervisors", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.date "career_start_date"
    t.integer "profession_id"
    t.string "contract_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "program", default: false
    t.boolean "course", default: false
    t.index ["contact_id"], name: "index_supervisors_on_contact_id", unique: true
  end

  create_table "taxations", id: :serial, force: :cascade do |t|
    t.decimal "socialsecurity", precision: 5, scale: 2
    t.integer "bracket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 150
    t.date "start"
    t.date "finish"
    t.boolean "pap", default: false
    t.boolean "medres", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "institution_id"
    t.integer "permission_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webinfos", id: :serial, force: :cascade do |t|
    t.string "email", limit: 100
    t.string "site", limit: 150
    t.string "facebook", limit: 40
    t.string "twitter", limit: 40
    t.string "other", limit: 40
    t.integer "institution_id"
    t.integer "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "regionaloffice_id"
    t.integer "council_id"
    t.index ["contact_id", "institution_id"], name: "index_webinfos_on_contact_id_and_institution_id"
  end

end
