class PoteSerializer < ActiveModel::Serializer

  attributes :pote_user, :pote_despesas, :pote_receita_fixa, :pote_receita_variaveis,
             :receita_mensal, :data_table

  before_filter :params_step

# Definindo metodos para auxiliar api no processo onboarding 
# (render json: @torre, methods: pote_conjuge)

if @step == 2
# Step 2
  def pote_user
    data_user_id = {
      nome: object.nome, idade: object.idade
    }
  end

  def pote_despesas
    data_despesas = {
      despesas: object.despesas
    }
  end

  def pote_receita_fixa
    data_conjuge = { 
      receita_concurso: object.receita_concurso, receita_clt: object.receita_clt, receita_aluguel: object.receita_aluguel, receita_prolabore: object.receita_prolabore,
      receita_fixa_outros: object.receita_fixa_outros, receita_fixa_subtotal: object.receita_fixa_subtotal, receita_variavel_subtotal: object.receita_variavel_subtotal,
      receita_fixa_total: object.receita_fixa_total, receita_concurso_conjuge: object.receita_concurso_conjuge, receita_clt_conjuge: object.receita_clt_conjuge, 
      receita_aluguel_conjuge: object.receita_aluguel_conjuge, receita_prolabore_conjuge: object.receita_prolabore_conjuge,
      receita_fixa_outros_conjuge: object.receita_fixa_outros_conjuge, receita_fixa_subtotal_conjuge: object.receita_fixa_subtotal_conjuge,
      receita_variavel_subtotal_conjuge: object.receita_variavel_subtotal_conjuge
    }
  end

  def pote_receita_variaveis
    data_variaveis = {
      receita_autonomo_pf: object.receita_autonomo_pf, receita_autonomo_pf_conjuge: object.receita_autonomo_pf_conjuge,
      receita_autonomo_pj: object.receita_autonomo_pj, receita_autonomo_pj_conjuge: object.receita_autonomo_pj_conjuge,
      receita_outros: object.receita_outros, receita_variavel_subtotal: object.receita_variavel_subtotal, 
      receita_variavel_subtotal_conjuge: object.receita_variavel_subtotal_conjuge, receita_variavel_total: object.receita_variavel_total
    }
  end

  def receita_mensal
    data_receita = {
      total_receita_mensal: object.receitas.reais, total_receita_cliente: object.total_receita_cliente.reais,
      total_receita_conjuge: object.total_receita_conjuge.reais, participacao_receitas: object.participacao_receitas.reais,
      participacao_receitas_conjuge: object.participacao_receitas_conjuge.reais, renda_garantida: object.renda_garantida,
      renda_garantida_conjuge: object.renda_garantida_conjuge, idade_independencia_financeira: object.idade_independencia_financeira,
      expectativa_vida: object.expectativa_vida
    }
  end
end

#Step 3
def data_table
  data_table = {
    tabela_necessidade_de_cobertura: object.total_receita_casal.reais
  }
end

def params_step
  @return_to = params[:return_to]
  @steps = params[:steps]
  @steps ||= '0,1,2,3,4,5,6,7'

  @step = params[:step] || 1
  @step = @step.to_i

  @next_step = @step + 1
  @next_step = 8 if @next_step >= 8 # U
end
end
