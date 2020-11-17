module Api
  module V1
    class onboardingController < ApiController
      def show
        @return_to = params[:return_to]
        @steps = params[:steps]
        @steps ||= '0,1,2,3,4,5,6,7'
    
        @step = params[:step] || 1
        @step = @step.to_i
    
        @next_step = @step + 1
        @next_step = 8 if @next_step >= 8 # Ultimo passo
    
        if params[:torre_id]
          @torre = Torre.find(params[:torre_id])
        else
          @torre = current_user.torre
        end
    
        if @step == 1
          @torre.dependentes = false if @torre.dependentes.nil?
          render json: {pote: @torre, endereco: @torre.enderecos, dependentes: @torre.filhos}
        end
    
        if @step == 2
          render json: @torre, methods: [:pote_user,
                                          :pote_despesas,
                                          :pote_receita_fixa, 
                                          :pote_receita_variaveis,
                                          :receita_mensal
                                        ]
        end

        if @step == 3
          render json: {id: @torre.id, nome: @torre.nome}
        end
    
        if @step == 4
          @torre.perfil.filhos.each do |f|
            if @torre.responsavel_protecao_educacao != 'titular'
              # TODO Fazer o inverso do que é feito para distribuir para o cônjuge.
              render json: {notice: "ok"}
            end
          end
        end
    
        if @step == 5
          @torre.gerar_tabela_de_seguros_padrao
          @torre.gerar_tabela_de_despesas_padrao
          @torre.gerar_tabela_de_necessidade_de_coberturas
          @torre.calcular_cobertura
          @torre.calcular_cobertura_conjuge
          @torre.calcular_pote_1
        end
    end
  end
end