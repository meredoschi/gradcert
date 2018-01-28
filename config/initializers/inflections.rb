# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:

ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'

 	inflect.irregular 'agência bancária', 'agências bancárias'
	inflect.irregular 'alocação', 'alocações'
	inflect.irregular 'alocação de vagas', 'alocações de vagas'
 	inflect.irregular 'anotação', 'anotações'
	inflect.irregular 'ano do programa', 'anos do programa'
  inflect.irregular 'Ano do programa', 'Anos de programa'
	inflect.irregular 'área profissional', 'áreas profissionais'
	inflect.irregular 'arquivo bancário', 'arquivos bancários'
  inflect.irregular 'avaliação', 'avaliações'
  inflect.irregular 'avaliação de programa', 'avaliações de programa'
	inflect.irregular 'bolsista', 'bolsistas'
	inflect.irregular 'categoria acadêmica', 'categorias acadêmicas'
  inflect.irregular 'centro de pesquisa', 'centros de pesquisa'
 	inflect.irregular 'conselho profissional', 'conselhos profissionais'
 	inflect.irregular 'conta bancária', 'conta bancárias'
  inflect.irregular 'coordenador de curso', 'coordenadores de curso'
  inflect.irregular 'conjunto de dados pessoais', 'dados pessoais'
  inflect.irregular 'cronograma de reposição', 'cronogramas de reposição'
  inflect.irregular 'dia', 'dias'
  inflect.irregular 'definição', 'definições'
  inflect.irregular 'desativação', 'desativações'
	inflect.irregular 'Departamento regional de saúde','Departamentos regionais de saúde'
  inflect.irregular 'docente supervisor', 'docentes supervisores'
	inflect.irregular 'envio complementar', 'envios complementares'
  inflect.irregular 'especialidade profissional', 'especialidades profissionais'
	inflect.irregular 'estado ou província', 'estados ou províncias'
  inflect.irregular 'estrutura de atendimento', 'estruturas de atendimento'
	inflect.irregular 'evento de cálculo', 'eventos de cálculo'
	inflect.irregular 'informe de situação de programa', 'informes de situação dos programas'
  inflect.irregular 'instituição', 'instituições'
  inflect.irregular 'instituição de ensino superior','instituições de ensino superior'
  inflect.irregular 'interação','interações'
  inflect.irregular 'falta', 'faltas'
  inflect.irregular 'família profissional', 'famílias profissionais'
  inflect.irregular 'ficha da instituição', 'fichas das instituições'
  inflect.irregular 'folha de pagamento', 'folhas de pagamento'
  inflect.irregular 'gestor', 'gestores'
  inflect.irregular 'pagamento bb', 'pagamentos bb'
  inflect.irregular 'processo seletivo', 'processos seletivos'
  inflect.irregular 'programa e curso', 'programas e cursos'
  inflect.irregular 'laudo do parecerista', 'laudos do parecerista'
  inflect.irregular 'membro da equipe', 'membros da equipe'
	inflect.irregular 'metodologia didática', 'metodologias didáticas'
	inflect.irregular 'nome de curso', 'nomes de curso'
	inflect.irregular 'nome de escola', 'nomes de escola'
	inflect.irregular 'nome de programa', 'nomes de programa'
  inflect.irregular 'país', 'países'
	inflect.irregular 'pagamento bancário', 'pagamentos bancários'
  inflect.irregular 'papel', 'papéis'
  inflect.irregular 'programa', 'programas'
  inflect.irregular 'parecer de programa', 'pareceres de programa'
  inflect.irregular 'perfil institucional', 'perfis institucionais'
  inflect.irregular 'período letivo', 'períodos letivos'
  inflect.irregular 'leave', 'leaves'
  inflect.irregular 'perfil', 'perfis' # to do: fix this for general case with regexp
  inflect.irregular 'permissão', 'permissões'
  inflect.irregular 'profissão', 'profissões'
	inflect.irregular 'programa sob análise', 'programas sob análise'
	inflect.irregular 'recomendação', 'recomendações'
  inflect.irregular 'região adm estadual', 'regiões adm estaduais'
  inflect.irregular 'registro encontrado', 'registros encontrados'
  inflect.irregular 'relatório disponível', 'relatórios disponíveis'
	inflect.irregular 'tipo de diploma', 'tipos de diploma'
	inflect.irregular 'tipo de licença', 'tipos de licença'
  inflect.irregular 'tipo de instituição', 'tipos de instituições'
	inflect.irregular 'tipo de instituição de ensino superior', 'tipos de instituições de ensino superior'
  inflect.irregular 'tipo de matrícula', 'tipos de matrícula'
	inflect.irregular 'tributação', 'tributações'
  inflect.irregular 'quadro de vagas', 'quadros de vagas'
  inflect.irregular 'unidade da federação', 'unidades da federação'
  inflect.irregular 'valor bolsa', 'valores bolsa'

 # 	http://pt.stackoverflow.com/questions/19512/como-programar-em-portugu%C3%AAs-no-ruby-on-rails
 #    inflect.plural(/or$/i,  'ores')
 #    inflect.singular(/ores$/i, 'or')
 end
