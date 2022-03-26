# frozen_string_literal: true

Bracket.create!([
                  { num: 1, start_cents: BigDecimal("190398"), finish_cents: BigDecimal("282665"), unlimited: false, taxation_id: 1, rate: 7.5, deductible_cents: BigDecimal("14280") },
                  { num: 2, start_cents: BigDecimal("282666"), finish_cents: BigDecimal("375105"), unlimited: false, taxation_id: 1, rate: 15.0, deductible_cents: BigDecimal("35480") },
                  { num: 3, start_cents: BigDecimal("375106"), finish_cents: BigDecimal("466468"), unlimited: false, taxation_id: 1, rate: 22.5, deductible_cents: BigDecimal("63613") },
                  { num: 4, start_cents: BigDecimal("466469"), finish_cents: BigDecimal("0"), unlimited: true, taxation_id: 1, rate: 27.5, deductible_cents: BigDecimal("86936") }
                ])
