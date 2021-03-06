# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20200113174039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academiccategories", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "academiccategories", ["name"], name: "index_academiccategories_on_name", unique: true, using: :btree

  create_table "accreditations", force: :cascade do |t|
    t.integer  "institution_id"
    t.date     "start"
    t.date     "renewal"
    t.boolean  "revoked"
    t.date     "revocation"
    t.string   "comment",         limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "suspension"
    t.boolean  "suspended"
    t.boolean  "original",                    default: false
    t.boolean  "renewed",                     default: false
    t.integer  "program_id"
    t.integer  "registration_id"
    t.boolean  "confirmed",                   default: false
  end

  add_index "accreditations", ["institution_id"], name: "index_accreditations_on_institution_id", unique: true, using: :btree
  add_index "accreditations", ["program_id"], name: "index_accreditations_on_program_id", using: :btree
  add_index "accreditations", ["registration_id"], name: "index_accreditations_on_registration_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "streetname_id"
    t.string   "addr",              limit: 200
    t.string   "complement",        limit: 50
    t.string   "neighborhood",      limit: 50
    t.integer  "municipality_id"
    t.string   "postalcode",        limit: 25
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id"
    t.integer  "country_id"
    t.integer  "contact_id"
    t.integer  "regionaloffice_id"
    t.integer  "program_id"
    t.string   "header",            limit: 120
    t.integer  "course_id"
    t.boolean  "internal",                      default: false
    t.integer  "council_id"
    t.integer  "streetnum"
    t.integer  "bankbranch_id"
  end

  add_index "addresses", ["bankbranch_id"], name: "index_addresses_on_bankbranch_id", using: :btree
  add_index "addresses", ["contact_id", "institution_id"], name: "index_addresses_on_contact_id_and_institution_id", using: :btree
  add_index "addresses", ["council_id"], name: "index_addresses_on_council_id", using: :btree
  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id", using: :btree
  add_index "addresses", ["course_id"], name: "index_addresses_on_course_id", using: :btree
  add_index "addresses", ["institution_id"], name: "index_addresses_on_institution_id", using: :btree
  add_index "addresses", ["municipality_id"], name: "index_addresses_on_municipality_id", using: :btree
  add_index "addresses", ["program_id"], name: "index_addresses_on_program_id", using: :btree
  add_index "addresses", ["regionaloffice_id"], name: "index_addresses_on_regionaloffice_id", using: :btree
  add_index "addresses", ["streetname_id"], name: "index_addresses_on_streetname_id", using: :btree

  create_table "admissions", force: :cascade do |t|
    t.date     "start"
    t.date     "finish"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "program_id",                             null: false
    t.integer  "grantsasked",                default: 0, null: false
    t.integer  "grantsgiven",                default: 0, null: false
    t.integer  "accreditedgrants",           default: 0, null: false
    t.integer  "appealsgrantedfinalexam",    default: 0, null: false
    t.integer  "appealsdeniedfinalexam",     default: 0, null: false
    t.integer  "candidates",                 default: 0, null: false
    t.integer  "absentfirstexam",            default: 0, null: false
    t.integer  "absentfinalexam",            default: 0, null: false
    t.integer  "passedfirstexam",            default: 0, null: false
    t.integer  "appealsdeniedfirstexam",     default: 0, null: false
    t.integer  "appealsgrantedfirstexam",    default: 0, null: false
    t.integer  "admitted",                   default: 0, null: false
    t.integer  "convoked",                   default: 0, null: false
    t.integer  "insufficientfinalexamgrade", default: 0, null: false
  end

  add_index "admissions", ["program_id"], name: "index_admissions_on_program_id", using: :btree

  create_table "annotations", force: :cascade do |t|
    t.integer  "registration_id",                              null: false
    t.integer  "payroll_id",                                   null: false
    t.integer  "absences"
    t.integer  "discount_cents"
    t.boolean  "skip",                         default: false
    t.string   "comment",          limit: 150
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "supplement_cents"
    t.boolean  "confirmed",                    default: false
    t.boolean  "automatic",                    default: false
  end

  add_index "annotations", ["payroll_id"], name: "index_annotations_on_payroll_id", using: :btree
  add_index "annotations", ["registration_id", "payroll_id"], name: "index_annotations_on_registration_id_and_payroll_id", using: :btree

  create_table "assessments", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "program_id"
    t.integer  "profession_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessments", ["contact_id"], name: "index_assessments_on_contact_id", using: :btree
  add_index "assessments", ["profession_id"], name: "index_assessments_on_profession_id", using: :btree
  add_index "assessments", ["program_id", "contact_id"], name: "index_assessments_on_program_id_and_contact_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.integer  "program_id"
    t.integer  "supervisor_id"
    t.date     "start_date"
    t.boolean  "main",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["program_id", "supervisor_id"], name: "index_assignments_on_program_id_and_supervisor_id", using: :btree
  add_index "assignments", ["supervisor_id"], name: "index_assignments_on_supervisor_id", using: :btree

  create_table "bankaccounts", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "student_id"
    t.integer  "bankbranch_id"
    t.string   "num",               limit: 10
    t.string   "verificationdigit", limit: 10
  end

  add_index "bankaccounts", ["bankbranch_id"], name: "index_bankaccounts_on_bankbranch_id", using: :btree
  add_index "bankaccounts", ["student_id"], name: "index_bankaccounts_on_student_id", using: :btree

  create_table "bankbranches", force: :cascade do |t|
    t.string   "code",              limit: 5
    t.string   "name",              limit: 100
    t.string   "formername",        limit: 50
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "verificationdigit", limit: 1
    t.date     "opened"
    t.integer  "address_id"
    t.integer  "phone_id"
    t.integer  "numericalcode"
  end

  add_index "bankbranches", ["address_id"], name: "index_bankbranches_on_address_id", using: :btree
  add_index "bankbranches", ["phone_id"], name: "index_bankbranches_on_phone_id", using: :btree

  create_table "bankpayments", force: :cascade do |t|
    t.integer  "payroll_id"
    t.string   "comment",           limit: 150
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "sequential"
    t.boolean  "prepared",                      default: false
    t.integer  "totalamount_cents",             default: 0
    t.boolean  "done",                          default: false
    t.boolean  "resend",                        default: false
    t.boolean  "statements",                    default: false
  end

  add_index "bankpayments", ["payroll_id"], name: "index_bankpayments_on_payroll_id", using: :btree

  create_table "brackets", force: :cascade do |t|
    t.integer  "num"
    t.integer  "start_cents"
    t.integer  "finish_cents"
    t.boolean  "unlimited",                                default: false
    t.integer  "taxation_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.decimal  "rate",             precision: 5, scale: 2, default: 0.0
    t.integer  "deductible_cents",                         default: 0
  end

  add_index "brackets", ["taxation_id"], name: "index_brackets_on_taxation_id", using: :btree

  create_table "characteristics", force: :cascade do |t|
    t.integer  "institution_id"
    t.string   "mission",                      limit: 800
    t.string   "corevalues",                   limit: 800
    t.string   "userprofile",                  limit: 800
    t.integer  "stateregion_id"
    t.string   "relationwithpublichealthcare", limit: 800
    t.string   "highlightareas",               limit: 800
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characteristics", ["institution_id"], name: "index_characteristics_on_institution_id", unique: true, using: :btree
  add_index "characteristics", ["stateregion_id"], name: "index_characteristics_on_stateregion_id", using: :btree

  create_table "colleges", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "area"
    t.integer  "classrooms"
    t.integer  "otherrooms"
    t.integer  "sportscourts"
    t.integer  "foodplaces"
    t.integer  "libraries"
    t.integer  "gradcertificatecourses"
    t.integer  "previousyeargradcertcompletions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colleges", ["institution_id"], name: "index_colleges_on_institution_id", unique: true, using: :btree

  create_table "completions", force: :cascade do |t|
    t.integer  "registration_id"
    t.boolean  "inprogress"
    t.boolean  "pass"
    t.boolean  "failure"
    t.boolean  "mustmakeup"
    t.boolean  "dnf"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "completions", ["registration_id"], name: "index_completions_on_registration_id", unique: true, using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id",                                     null: false
    t.integer  "role_id"
    t.date     "termstart"
    t.date     "termfinish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",            limit: 200,                 null: false
    t.string   "image"
    t.integer  "address_id"
    t.integer  "phone_id"
    t.integer  "webinfo_id"
    t.integer  "personalinfo_id"
    t.boolean  "confirmed",                   default: false
  end

  add_index "contacts", ["address_id"], name: "index_contacts_on_address_id", using: :btree
  add_index "contacts", ["personalinfo_id"], name: "index_contacts_on_personalinfo_id", using: :btree
  add_index "contacts", ["phone_id"], name: "index_contacts_on_phone_id", using: :btree
  add_index "contacts", ["role_id"], name: "index_contacts_on_role_id", using: :btree
  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", unique: true, using: :btree
  add_index "contacts", ["webinfo_id"], name: "index_contacts_on_webinfo_id", using: :btree

  create_table "councils", force: :cascade do |t|
    t.string   "name",         limit: 150, null: false
    t.integer  "address_id"
    t.integer  "phone_id"
    t.integer  "webinfo_id"
    t.integer  "state_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "abbreviation", limit: 20
  end

  add_index "councils", ["address_id"], name: "index_councils_on_address_id", using: :btree
  add_index "councils", ["name", "state_id"], name: "index_councils_on_name_and_state_id", using: :btree
  add_index "councils", ["phone_id"], name: "index_councils_on_phone_id", using: :btree
  add_index "councils", ["state_id"], name: "index_councils_on_state_id", using: :btree
  add_index "councils", ["webinfo_id"], name: "index_councils_on_webinfo_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "brname",     limit: 70, null: false
    t.string   "name",       limit: 70, null: false
    t.string   "a2",         limit: 2
    t.string   "a3",         limit: 3
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "coursenames", force: :cascade do |t|
    t.string   "name",         limit: 200
    t.boolean  "active",                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "previousname", limit: 100
    t.integer  "legacycode"
    t.integer  "school_id"
    t.boolean  "pap",                      default: false
    t.boolean  "medres",                   default: false
  end

  add_index "coursenames", ["name"], name: "index_coursenames_on_name", unique: true, using: :btree
  add_index "coursenames", ["school_id"], name: "index_coursenames_on_school_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.integer  "coursename_id"
    t.integer  "professionalfamily_id"
    t.boolean  "practical",                            default: false
    t.boolean  "core",                                 default: false
    t.boolean  "professionalrequirement",              default: false
    t.integer  "supervisor_id"
    t.integer  "methodology_id"
    t.integer  "address_id"
    t.integer  "workload"
    t.string   "syllabus",                limit: 4000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
  end

  add_index "courses", ["address_id"], name: "index_courses_on_address_id", using: :btree
  add_index "courses", ["coursename_id"], name: "index_courses_on_coursename_id", using: :btree
  add_index "courses", ["methodology_id"], name: "index_courses_on_methodology_id", using: :btree
  add_index "courses", ["professionalfamily_id"], name: "index_courses_on_professionalfamily_id", using: :btree
  add_index "courses", ["program_id"], name: "index_courses_on_program_id", using: :btree
  add_index "courses", ["supervisor_id"], name: "index_courses_on_supervisor_id", using: :btree

  create_table "degreetypes", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.boolean  "pap",                    default: false
    t.boolean  "medres",                 default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "diplomas", force: :cascade do |t|
    t.integer  "profession_id"
    t.integer  "institution_id"
    t.string   "externalinstitution"
    t.date     "awarded"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supervisor_id"
    t.integer  "degreetype_id"
    t.boolean  "ongoing",                                 default: false
    t.integer  "student_id"
    t.integer  "schoolname_id"
    t.integer  "coursename_id"
    t.integer  "council_id"
    t.string   "councilcredential",           limit: 30
    t.integer  "school_id"
    t.string   "othercourse",                 limit: 100
    t.string   "councilcredentialstatus",     limit: 30
    t.date     "councilcredentialexpiration"
  end

  add_index "diplomas", ["council_id"], name: "index_diplomas_on_council_id", using: :btree
  add_index "diplomas", ["coursename_id"], name: "index_diplomas_on_coursename_id", using: :btree
  add_index "diplomas", ["degreetype_id"], name: "index_diplomas_on_degreetype_id", using: :btree
  add_index "diplomas", ["institution_id"], name: "index_diplomas_on_institution_id", using: :btree
  add_index "diplomas", ["profession_id"], name: "index_diplomas_on_profession_id", using: :btree
  add_index "diplomas", ["school_id"], name: "index_diplomas_on_school_id", using: :btree
  add_index "diplomas", ["schoolname_id"], name: "index_diplomas_on_schoolname_id", using: :btree
  add_index "diplomas", ["student_id"], name: "index_diplomas_on_student_id", using: :btree
  add_index "diplomas", ["supervisor_id"], name: "index_diplomas_on_supervisor_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.date     "start"
    t.date     "finish"
    t.integer  "leavetype_id"
    t.boolean  "absence",                 default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "registration_id"
    t.integer  "daystarted",              default: 0
    t.integer  "dayfinished",             default: 0
    t.integer  "annotation_id"
    t.boolean  "residual",                default: false
    t.boolean  "confirmed",               default: false
    t.boolean  "processed",               default: false
    t.string   "supportingdocumentation"
  end

  add_index "events", ["annotation_id"], name: "index_events_on_annotation_id", using: :btree
  add_index "events", ["leavetype_id"], name: "index_events_on_leavetype_id", using: :btree
  add_index "events", ["registration_id", "start"], name: "index_events_on_registration_id_and_start", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "registration_id"
    t.date     "processingdate"
    t.boolean  "approved",                    default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "payroll_id"
    t.boolean  "processed",                   default: true
    t.integer  "bankpayment_id"
    t.string   "comment",         limit: 200
  end

  add_index "feedbacks", ["bankpayment_id"], name: "index_feedbacks_on_bankpayment_id", using: :btree
  add_index "feedbacks", ["payroll_id"], name: "index_feedbacks_on_payroll_id", using: :btree
  add_index "feedbacks", ["registration_id"], name: "index_feedbacks_on_registration_id", using: :btree

  create_table "fundings", force: :cascade do |t|
    t.integer  "government"
    t.integer  "agreements"
    t.integer  "privatesector"
    t.integer  "other"
    t.integer  "ppp"
    t.boolean  "percentvalues",                 default: false
    t.string   "comment",           limit: 200
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "characteristic_id",                             null: false
  end

  add_index "fundings", ["characteristic_id"], name: "index_fundings_on_characteristic_id", using: :btree

  create_table "healthcareinfos", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "totalbeds"
    t.integer  "icubeds"
    t.integer  "ambulatoryrooms"
    t.integer  "labs"
    t.integer  "emergencyroombeds"
    t.string   "equipmenthighlights", limit: 800
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consultations"
    t.integer  "admissions"
    t.integer  "radiologyprocedures"
    t.integer  "labexams"
    t.integer  "surgeries"
  end

  add_index "healthcareinfos", ["institution_id"], name: "index_healthcareinfos_on_institution_id", unique: true, using: :btree

  create_table "institutions", force: :cascade do |t|
    t.string   "name",               limit: 250,                 null: false
    t.integer  "institutiontype_id"
    t.boolean  "provisional",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sector",             limit: 40
    t.integer  "address_id"
    t.integer  "phone_id"
    t.integer  "webinfo_id"
    t.integer  "accreditation_id"
    t.boolean  "undergraduate",                  default: false
    t.integer  "legacycode"
    t.string   "abbreviation",       limit: 20
  end

  add_index "institutions", ["accreditation_id"], name: "index_institutions_on_accreditation_id", using: :btree
  add_index "institutions", ["address_id"], name: "index_institutions_on_address_id", using: :btree
  add_index "institutions", ["institutiontype_id"], name: "index_institutions_on_institutiontype_id", using: :btree
  add_index "institutions", ["name"], name: "index_institutions_on_name", unique: true, using: :btree
  add_index "institutions", ["phone_id"], name: "index_institutions_on_phone_id", using: :btree
  add_index "institutions", ["webinfo_id"], name: "index_institutions_on_webinfo_id", using: :btree

  create_table "institutiontypes", force: :cascade do |t|
    t.string   "name",       limit: 70, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutiontypes", ["name"], name: "index_institutiontypes_on_name", unique: true, using: :btree

  create_table "leavetypes", force: :cascade do |t|
    t.string   "name",        limit: 100
    t.boolean  "paid",                    default: false
    t.string   "comment",     limit: 200
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "setnumdays"
    t.integer  "dayspaidcap"
    t.boolean  "pap",                     default: false
    t.boolean  "medres",                  default: false
    t.integer  "maxnumdays",              default: 731
    t.boolean  "vacation",                default: false
  end

  add_index "leavetypes", ["name"], name: "index_leavetypes_on_name", unique: true, using: :btree

  create_table "makeupschedules", force: :cascade do |t|
    t.date     "start"
    t.date     "finish"
    t.integer  "registration_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "makeupschedules", ["registration_id"], name: "index_makeupschedules_on_registration_id", unique: true, using: :btree

  create_table "methodologies", force: :cascade do |t|
    t.string   "kind",       limit: 120
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "methodologies", ["kind"], name: "index_methodologies_on_kind", unique: true, using: :btree

  create_table "municipalities", force: :cascade do |t|
    t.string  "name",               limit: 50,                 null: false
    t.integer "stateregion_id"
    t.integer "codmuni"
    t.boolean "capital",                       default: false
    t.integer "regionaloffice_id"
    t.string  "asciiname",          limit: 50
    t.string  "namewithstate"
    t.string  "asciinamewithstate"
  end

  add_index "municipalities", ["asciinamewithstate"], name: "index_municipalities_on_asciinamewithstate", unique: true, using: :btree
  add_index "municipalities", ["name", "stateregion_id"], name: "index_municipalities_on_name_and_stateregion_id", unique: true, using: :btree
  add_index "municipalities", ["namewithstate"], name: "index_municipalities_on_namewithstate", unique: true, using: :btree
  add_index "municipalities", ["regionaloffice_id"], name: "index_municipalities_on_regionaloffice_id", using: :btree
  add_index "municipalities", ["stateregion_id"], name: "index_municipalities_on_stateregion_id", using: :btree

  create_table "payrolls", force: :cascade do |t|
    t.date     "paymentdate",                                 null: false
    t.string   "comment",         limit: 200
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "amount_cents",                default: 0,     null: false
    t.integer  "taxation_id"
    t.date     "monthworked"
    t.integer  "scholarship_id"
    t.boolean  "special",                     default: false
    t.integer  "daystarted",                  default: 0
    t.integer  "dayfinished",                 default: 0
    t.boolean  "annotated",                   default: false
    t.boolean  "pap",                         default: false
    t.boolean  "medres",                      default: false
    t.datetime "dataentrystart"
    t.datetime "dataentryfinish"
  end

  add_index "payrolls", ["scholarship_id"], name: "index_payrolls_on_scholarship_id", using: :btree
  add_index "payrolls", ["taxation_id"], name: "index_payrolls_on_taxation_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "kind",        limit: 50,  null: false
    t.string   "description", limit: 150
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalinfos", force: :cascade do |t|
    t.string   "sex",                  limit: 1
    t.string   "gender",               limit: 1
    t.date     "dob"
    t.string   "idtype",               limit: 40
    t.string   "idnumber",             limit: 20
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "socialsecuritynumber", limit: 20
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "tin",                  limit: 20
    t.string   "othername",            limit: 30
    t.integer  "contact_id"
    t.string   "mothersname",          limit: 100
  end

  add_index "personalinfos", ["contact_id"], name: "index_personalinfos_on_contact_id", unique: true, using: :btree
  add_index "personalinfos", ["country_id"], name: "index_personalinfos_on_country_id", using: :btree
  add_index "personalinfos", ["state_id"], name: "index_personalinfos_on_state_id", using: :btree
  add_index "personalinfos", ["tin"], name: "index_personalinfos_on_tin", using: :btree

  create_table "phones", force: :cascade do |t|
    t.string   "main",              limit: 30
    t.string   "mobile",            limit: 30
    t.string   "other",             limit: 30
    t.integer  "contact_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "regionaloffice_id"
    t.integer  "council_id"
    t.string   "fax",               limit: 20
    t.integer  "bankbranch_id"
  end

  add_index "phones", ["bankbranch_id"], name: "index_phones_on_bankbranch_id", using: :btree
  add_index "phones", ["contact_id", "institution_id"], name: "index_phones_on_contact_id_and_institution_id", using: :btree
  add_index "phones", ["council_id"], name: "index_phones_on_council_id", using: :btree
  add_index "phones", ["institution_id"], name: "index_phones_on_institution_id", using: :btree
  add_index "phones", ["regionaloffice_id"], name: "index_phones_on_regionaloffice_id", using: :btree

  create_table "placesavailables", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "schoolterm_id"
    t.integer  "requested"
    t.integer  "accredited"
    t.integer  "authorized"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "allowregistrations", default: false
  end

  add_index "placesavailables", ["institution_id"], name: "index_placesavailables_on_institution_id", using: :btree
  add_index "placesavailables", ["schoolterm_id"], name: "index_placesavailables_on_schoolterm_id", using: :btree

  create_table "professionalareas", force: :cascade do |t|
    t.string   "name",         limit: 100
    t.string   "previouscode", limit: 10
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "previousname", limit: 150
    t.string   "comment",      limit: 250
    t.boolean  "pap",                      default: false
    t.boolean  "medres",                   default: false
    t.boolean  "legacy",                   default: false
  end

  create_table "professionalfamilies", force: :cascade do |t|
    t.string   "name",        limit: 150,                 null: false
    t.integer  "subgroup_id"
    t.integer  "familycode"
    t.boolean  "pap",                     default: false
    t.boolean  "medres",                  default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "council_id"
  end

  add_index "professionalfamilies", ["council_id"], name: "index_professionalfamilies_on_council_id", using: :btree
  add_index "professionalfamilies", ["subgroup_id"], name: "index_professionalfamilies_on_subgroup_id", using: :btree

  create_table "professionalspecialties", force: :cascade do |t|
    t.string   "name",                limit: 100
    t.string   "previouscode",        limit: 10
    t.integer  "professionalarea_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "previousname",        limit: 150
    t.string   "comment",             limit: 250
    t.boolean  "pap",                             default: false
    t.boolean  "medres",                          default: false
    t.boolean  "legacy",                          default: false
  end

  add_index "professionalspecialties", ["professionalarea_id"], name: "index_professionalspecialties_on_professionalarea_id", using: :btree

  create_table "professions", force: :cascade do |t|
    t.string   "name",                  limit: 150, null: false
    t.integer  "occupationcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "professionalfamily_id"
    t.string   "asciiname",             limit: 150
  end

  add_index "professions", ["name"], name: "index_professions_on_name", unique: true, using: :btree
  add_index "professions", ["professionalfamily_id"], name: "index_professions_on_professionalfamily_id", using: :btree

  create_table "programnames", force: :cascade do |t|
    t.string   "name",         limit: 200,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pap",                      default: false
    t.boolean  "medres",                   default: false
    t.boolean  "active",                   default: true
    t.string   "previousname", limit: 200
    t.string   "comment",      limit: 200
    t.boolean  "legacy",                   default: false
    t.integer  "ancestor_id"
    t.boolean  "gradcert",                 default: false
  end

  add_index "programnames", ["ancestor_id"], name: "index_programnames_on_ancestor_id", using: :btree
  add_index "programnames", ["name"], name: "index_programnames_on_name", unique: true, using: :btree

  create_table "programs", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "programname_id"
    t.integer  "duration"
    t.string   "comment",                  limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pap",                                  default: false
    t.boolean  "medres",                               default: false
    t.integer  "address_id"
    t.boolean  "internal",                             default: true
    t.integer  "accreditation_id"
    t.integer  "admission_id"
    t.integer  "schoolterm_id"
    t.integer  "professionalspecialty_id"
    t.string   "previouscode",             limit: 8
    t.integer  "parentid"
    t.boolean  "gradcert",                             default: false
  end

  add_index "programs", ["accreditation_id"], name: "index_programs_on_accreditation_id", using: :btree
  add_index "programs", ["address_id"], name: "index_programs_on_address_id", using: :btree
  add_index "programs", ["admission_id"], name: "index_programs_on_admission_id", using: :btree
  add_index "programs", ["institution_id", "programname_id"], name: "index_programs_on_institution_id_and_programname_id", using: :btree
  add_index "programs", ["professionalspecialty_id"], name: "index_programs_on_professionalspecialty_id", using: :btree
  add_index "programs", ["programname_id", "institution_id", "schoolterm_id"], name: "index_programs_on_name_inst_schoolterm", unique: true, using: :btree
  add_index "programs", ["schoolterm_id"], name: "index_programs_on_schoolterm_id", using: :btree

  create_table "programsituations", force: :cascade do |t|
    t.integer  "assessment_id"
    t.integer  "recommended_duration"
    t.string   "goals",                limit: 3000
    t.string   "kind",                 limit: 3000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorable",                         default: false
  end

  add_index "programsituations", ["assessment_id"], name: "index_programsituations_on_assessment_id", unique: true, using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "programsituation_id"
    t.integer  "grants"
    t.integer  "theory"
    t.integer  "practice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "programyear"
  end

  add_index "recommendations", ["programsituation_id"], name: "index_recommendations_on_programsituation_id", using: :btree

  create_table "regionaloffices", force: :cascade do |t|
    t.string   "name",          limit: 100, null: false
    t.integer  "num"
    t.integer  "address_id"
    t.integer  "phone_id"
    t.integer  "webinfo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "directorsname", limit: 120, null: false
  end

  add_index "regionaloffices", ["address_id"], name: "index_regionaloffices_on_address_id", using: :btree
  add_index "regionaloffices", ["phone_id"], name: "index_regionaloffices_on_phone_id", using: :btree
  add_index "regionaloffices", ["webinfo_id"], name: "index_regionaloffices_on_webinfo_id", using: :btree

  create_table "registrationkinds", force: :cascade do |t|
    t.boolean  "regular",                default: true
    t.boolean  "makeup",                 default: false
    t.boolean  "repeat",                 default: false
    t.boolean  "veteran",                default: false
    t.integer  "previousregistrationid"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "registration_id"
  end

  add_index "registrationkinds", ["registration_id"], name: "index_registrationkinds_on_registration_id", unique: true, using: :btree

  create_table "registrations", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "schoolyear_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "comment",             limit: 150
    t.integer  "accreditation_id"
    t.boolean  "pap",                             default: false
    t.boolean  "medres",                          default: false
    t.boolean  "returned",                        default: false
    t.float    "finalgrade",                      default: 0.0
    t.integer  "completion_id"
    t.integer  "registrationkind_id"
  end

  add_index "registrations", ["accreditation_id"], name: "index_registrations_on_accreditation_id", using: :btree
  add_index "registrations", ["completion_id"], name: "index_registrations_on_completion_id", using: :btree
  add_index "registrations", ["registrationkind_id"], name: "index_registrations_on_registrationkind_id", using: :btree
  add_index "registrations", ["schoolyear_id"], name: "index_registrations_on_schoolyear_id", using: :btree
  add_index "registrations", ["student_id", "schoolyear_id"], name: "index_registrations_on_student_id_and_schoolyear_id", unique: true, using: :btree

  create_table "researchcenters", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "rooms"
    t.integer  "labs"
    t.integer  "intlprojectsdone"
    t.integer  "ongoingintlprojects"
    t.integer  "domesticprojectsdone"
    t.integer  "ongoingdomesticprojects"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "researchcenters", ["institution_id"], name: "index_researchcenters_on_institution_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",         limit: 120,                 null: false
    t.boolean  "management",               default: false
    t.boolean  "teaching",                 default: false
    t.boolean  "clerical",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pap"
    t.boolean  "medres"
    t.boolean  "collaborator",             default: false
    t.boolean  "student",                  default: false
    t.boolean  "itstaff",                  default: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "rosters", force: :cascade do |t|
    t.integer  "institution_id",                    null: false
    t.integer  "schoolterm_id",                     null: false
    t.integer  "authorizedsupervisors", default: 0
    t.datetime "dataentrystart",                    null: false
    t.datetime "dataentryfinish",                   null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "rosters", ["institution_id", "schoolterm_id"], name: "index_rosters_on_institution_id_and_schoolterm_id", unique: true, using: :btree
  add_index "rosters", ["schoolterm_id"], name: "index_rosters_on_schoolterm_id", using: :btree

  create_table "scholarships", force: :cascade do |t|
    t.integer  "amount_cents",                    default: 0
    t.date     "start"
    t.date     "finish"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "pap",                             default: false
    t.boolean  "medres",                          default: false
    t.string   "comment",             limit: 150
    t.integer  "partialamount_cents",             default: 0
    t.string   "name",                limit: 100
    t.integer  "daystarted",                      default: 0
    t.integer  "dayfinished",                     default: 0
    t.string   "writtenform",         limit: 200
    t.string   "writtenformpartial",  limit: 200
  end

  create_table "schoolnames", force: :cascade do |t|
    t.string   "name",         limit: 200
    t.string   "previousname", limit: 200
    t.boolean  "active",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",                limit: 120
    t.string   "abbreviation",        limit: 25
    t.integer  "ministrycode"
    t.integer  "academiccategory_id"
    t.boolean  "public",                          default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "schools", ["academiccategory_id"], name: "index_schools_on_academiccategory_id", using: :btree
  add_index "schools", ["ministrycode"], name: "index_schools_on_ministrycode", unique: true, using: :btree

  create_table "schoolterms", force: :cascade do |t|
    t.date     "start",                               null: false
    t.date     "finish",                              null: false
    t.boolean  "pap",                 default: false
    t.boolean  "medres",              default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "registrationseason",  default: false
    t.integer  "scholarshipsoffered", default: 0
    t.datetime "seasondebut"
    t.datetime "seasonclosure"
    t.datetime "admissionsdebut"
    t.datetime "admissionsclosure"
  end

  create_table "schooltypes", force: :cascade do |t|
    t.string   "name",       limit: 70
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "schooltypes", ["name"], name: "index_schooltypes_on_name", unique: true, using: :btree

  create_table "schoolyears", force: :cascade do |t|
    t.integer  "programyear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.integer  "pass"
    t.integer  "theory",      default: 0
    t.integer  "practice",    default: 0
  end

  add_index "schoolyears", ["program_id"], name: "index_schoolyears_on_program_id", using: :btree

  create_table "statements", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "grossamount_cents"
    t.integer  "incometax_cents"
    t.integer  "socialsecurity_cents"
    t.integer  "childsupport_cents"
    t.integer  "netamount_cents"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "bankpayment_id"
  end

  add_index "statements", ["bankpayment_id"], name: "index_statements_on_bankpayment_id", using: :btree
  add_index "statements", ["registration_id", "bankpayment_id"], name: "index_statements_on_registration_id_and_bankpayment_id", unique: true, using: :btree

  create_table "stateregions", force: :cascade do |t|
    t.string   "name",       limit: 70, null: false
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stateregions", ["state_id", "name"], name: "index_stateregions_on_state_id_and_name", using: :btree

  create_table "states", force: :cascade do |t|
    t.string  "name",         limit: 80, null: false
    t.string  "abbreviation", limit: 10
    t.integer "country_id"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree
  add_index "states", ["name"], name: "index_states_on_name", unique: true, using: :btree

  create_table "streetnames", force: :cascade do |t|
    t.string   "designation", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "streetnames", ["designation"], name: "index_streetnames_on_designation", unique: true, using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "contact_id",                                         null: false
    t.integer  "profession_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "bankaccount_id"
    t.integer  "previouscode",             limit: 8
    t.integer  "schoolterm_id"
    t.boolean  "previousparticipant",                default: false
    t.boolean  "nationalhealthcareworker",           default: false
  end

  add_index "students", ["bankaccount_id"], name: "index_students_on_bankaccount_id", unique: true, using: :btree
  add_index "students", ["contact_id"], name: "index_students_on_contact_id", using: :btree
  add_index "students", ["profession_id"], name: "index_students_on_profession_id", using: :btree
  add_index "students", ["schoolterm_id"], name: "index_students_on_schoolterm_id", using: :btree

  create_table "supervisors", force: :cascade do |t|
    t.integer  "contact_id"
    t.date     "career_start_date"
    t.integer  "profession_id"
    t.string   "contract_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "program",           default: false
    t.boolean  "course",            default: false
  end

  add_index "supervisors", ["contact_id"], name: "index_supervisors_on_contact_id", unique: true, using: :btree
  add_index "supervisors", ["profession_id"], name: "index_supervisors_on_profession_id", using: :btree

  create_table "taxations", force: :cascade do |t|
    t.decimal  "socialsecurity",             precision: 5, scale: 2
    t.integer  "bracket_id"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "name",           limit: 150
    t.date     "start"
    t.date     "finish"
    t.boolean  "pap",                                                default: false
    t.boolean  "medres",                                             default: false
  end

  add_index "taxations", ["bracket_id"], name: "index_taxations_on_bracket_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id"
    t.integer  "permission_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["institution_id"], name: "index_users_on_institution_id", using: :btree
  add_index "users", ["permission_id"], name: "index_users_on_permission_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "webinfos", force: :cascade do |t|
    t.string   "email",             limit: 100
    t.string   "site",              limit: 150
    t.string   "facebook",          limit: 40
    t.string   "twitter",           limit: 40
    t.string   "other",             limit: 40
    t.integer  "institution_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "regionaloffice_id"
    t.integer  "council_id"
  end

  add_index "webinfos", ["contact_id", "institution_id"], name: "index_webinfos_on_contact_id_and_institution_id", using: :btree
  add_index "webinfos", ["council_id"], name: "index_webinfos_on_council_id", using: :btree
  add_index "webinfos", ["institution_id"], name: "index_webinfos_on_institution_id", using: :btree
  add_index "webinfos", ["regionaloffice_id"], name: "index_webinfos_on_regionaloffice_id", using: :btree

  add_foreign_key "accreditations", "institutions"
  add_foreign_key "accreditations", "programs"
  add_foreign_key "accreditations", "registrations"
  add_foreign_key "addresses", "bankbranches"
  add_foreign_key "addresses", "contacts"
  add_foreign_key "addresses", "councils"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "courses"
  add_foreign_key "addresses", "institutions"
  add_foreign_key "addresses", "municipalities"
  add_foreign_key "addresses", "programs"
  add_foreign_key "addresses", "regionaloffices"
  add_foreign_key "addresses", "streetnames"
  add_foreign_key "admissions", "programs"
  add_foreign_key "annotations", "payrolls"
  add_foreign_key "annotations", "registrations"
  add_foreign_key "assessments", "contacts"
  add_foreign_key "assessments", "professions"
  add_foreign_key "assessments", "programs"
  add_foreign_key "assignments", "programs"
  add_foreign_key "assignments", "supervisors"
  add_foreign_key "bankaccounts", "bankbranches"
  add_foreign_key "bankaccounts", "students"
  add_foreign_key "bankbranches", "addresses"
  add_foreign_key "bankbranches", "phones"
  add_foreign_key "bankpayments", "payrolls"
  add_foreign_key "brackets", "taxations"
  add_foreign_key "characteristics", "institutions"
  add_foreign_key "characteristics", "stateregions"
  add_foreign_key "colleges", "institutions"
  add_foreign_key "completions", "registrations"
  add_foreign_key "contacts", "addresses"
  add_foreign_key "contacts", "personalinfos"
  add_foreign_key "contacts", "phones"
  add_foreign_key "contacts", "roles"
  add_foreign_key "contacts", "users"
  add_foreign_key "contacts", "webinfos"
  add_foreign_key "councils", "addresses"
  add_foreign_key "councils", "phones"
  add_foreign_key "councils", "states"
  add_foreign_key "councils", "webinfos"
  add_foreign_key "coursenames", "schools"
  add_foreign_key "courses", "addresses"
  add_foreign_key "courses", "coursenames"
  add_foreign_key "courses", "methodologies"
  add_foreign_key "courses", "professionalfamilies"
  add_foreign_key "courses", "programs"
  add_foreign_key "courses", "supervisors"
  add_foreign_key "diplomas", "councils"
  add_foreign_key "diplomas", "coursenames"
  add_foreign_key "diplomas", "degreetypes"
  add_foreign_key "diplomas", "institutions"
  add_foreign_key "diplomas", "professions"
  add_foreign_key "diplomas", "schoolnames"
  add_foreign_key "diplomas", "schools"
  add_foreign_key "diplomas", "students"
  add_foreign_key "diplomas", "supervisors"
  add_foreign_key "events", "annotations"
  add_foreign_key "events", "leavetypes"
  add_foreign_key "events", "registrations"
  add_foreign_key "feedbacks", "bankpayments"
  add_foreign_key "feedbacks", "payrolls"
  add_foreign_key "feedbacks", "registrations"
  add_foreign_key "fundings", "characteristics"
  add_foreign_key "healthcareinfos", "institutions"
  add_foreign_key "institutions", "accreditations"
  add_foreign_key "institutions", "addresses"
  add_foreign_key "institutions", "institutiontypes"
  add_foreign_key "institutions", "phones"
  add_foreign_key "institutions", "webinfos"
  add_foreign_key "makeupschedules", "registrations"
  add_foreign_key "municipalities", "stateregions"
  add_foreign_key "payrolls", "scholarships"
  add_foreign_key "payrolls", "taxations"
  add_foreign_key "personalinfos", "contacts"
  add_foreign_key "personalinfos", "countries"
  add_foreign_key "personalinfos", "states"
  add_foreign_key "phones", "bankbranches"
  add_foreign_key "phones", "contacts"
  add_foreign_key "phones", "councils"
  add_foreign_key "phones", "institutions"
  add_foreign_key "phones", "regionaloffices"
  add_foreign_key "placesavailables", "institutions"
  add_foreign_key "placesavailables", "schoolterms"
  add_foreign_key "professionalfamilies", "councils"
  add_foreign_key "professionalspecialties", "professionalareas"
  add_foreign_key "professions", "professionalfamilies"
  add_foreign_key "programs", "accreditations"
  add_foreign_key "programs", "addresses"
  add_foreign_key "programs", "admissions"
  add_foreign_key "programs", "institutions"
  add_foreign_key "programs", "programnames"
  add_foreign_key "programs", "schoolterms"
  add_foreign_key "programsituations", "assessments"
  add_foreign_key "recommendations", "programsituations"
  add_foreign_key "regionaloffices", "addresses"
  add_foreign_key "regionaloffices", "phones"
  add_foreign_key "regionaloffices", "webinfos"
  add_foreign_key "registrationkinds", "registrations"
  add_foreign_key "registrations", "accreditations"
  add_foreign_key "registrations", "completions"
  add_foreign_key "registrations", "registrationkinds"
  add_foreign_key "registrations", "schoolyears"
  add_foreign_key "registrations", "students"
  add_foreign_key "researchcenters", "institutions"
  add_foreign_key "rosters", "institutions"
  add_foreign_key "rosters", "schoolterms"
  add_foreign_key "schools", "academiccategories"
  add_foreign_key "schoolyears", "programs"
  add_foreign_key "statements", "bankpayments"
  add_foreign_key "statements", "registrations"
  add_foreign_key "stateregions", "states"
  add_foreign_key "states", "countries"
  add_foreign_key "students", "bankaccounts"
  add_foreign_key "students", "contacts"
  add_foreign_key "students", "professions"
  add_foreign_key "students", "schoolterms"
  add_foreign_key "supervisors", "contacts"
  add_foreign_key "supervisors", "professions"
  add_foreign_key "taxations", "brackets"
  add_foreign_key "users", "institutions"
  add_foreign_key "users", "permissions"
  add_foreign_key "webinfos", "contacts"
  add_foreign_key "webinfos", "councils"
  add_foreign_key "webinfos", "institutions"
  add_foreign_key "webinfos", "regionaloffices"
end
