class OrcEmpenhosController < ApplicationController
  # GET /orc_empenhos
  # GET /orc_empenhos.xml

     before_filter :load_iniciais

 def load_iniciais
        @pedidos_compra = OrcPedidoCompra.all(:order => 'codigo ASC')
        @despesas = OrcUniDespesa.all(:conditions => ["ano = ?", Time.now.year])
        @fichas_emp = OrcFicha.all(:conditions => ["ano = ?", Time.now.year], :order => 'ficha ASC')
        @fichas = OrcEmpenho.find_by_sql("SELECT DISTINCT (fc.ficha) as ficha, emp.orc_pedido_compra_id, fc.id FROM orc_empenhos emp INNER JOIN orc_pedido_compras pc ON emp.orc_pedido_compra_id = pc.id INNER JOIN orc_fichas fc ON pc.orc_ficha_id = fc.id WHERE (fc.ano = "+(Time.now.year).to_s+" AND emp.id !=1 ) ORDER BY fc.ficha ASC")

        @orcamentarias= OrcUniOrcamentaria.find(:all, :conditions => ["ano = ?", Time.now.year])
          @orc_pedido_ano= OrcPedidoCompra.find(:all, :select => 'distinct(ano)')
 end


  def index
    @orc_empenhos = OrcEmpenho.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orc_empenhos }
    end
  end

  # GET /orc_empenhos/1
  # GET /orc_empenhos/1.xml
  def show
    @orc_empenho = OrcEmpenho.find(params[:id])
    @orc_empenho_itens = OrcEmpenhoIten.find(:all, :conditions => ['orc_empenho_id=? ',@orc_empenho.id ])
    @ficha = OrcFicha.find(:all, :conditions => ['id =?', @orc_empenho.ficha_id])
    session[:emp_id] = @orc_empenho.id
    session[:id_empenho_show]= params[:id]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @orc_empenho }
    end
  end

  # GET /orc_empenhos/new
  # GET /orc_empenhos/new.xml
  def new
    @orc_empenho = OrcEmpenho.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @orc_empenho }
    end
  end


 def new_itens
    @orc_empenho = OrcEmpenho.find(session[:news_itens])


  end

  # GET /orc_empenhos/1/edit
  def edit
    @orc_empenho = OrcEmpenho.find(params[:id])
    w=params[:id]
    @orc_empenho_itens = OrcEmpenhoIten.find(:all, :conditions => ['orc_empenho_id=? ',@orc_empenho.id ])


    session[:news_itens]= @orc_empenho.id
   # session[:emp_id]
   # if !session[:emp_id].nil?
   #     @orc_empenho_itens = OrcEmpenhoIten.find(:all, :conditions =>['Orc_empenho_id=?', session[:emp_id]])
   #     session[:emp_id]= nil
   # end
    
  end

  # POST /orc_empenhos
  # POST /orc_empenhos.xml
  def create   
      @orc_empenho = OrcEmpenho.new(params[:orc_empenho])

    respond_to do |format|
      if @orc_empenho.save
        session[:news_itens]= @orc_empenho.id
        @ficha = OrcFicha.find(:all, :conditions => ['id =?',  session[:ficha_id]])

        @orc_empenho.ficha_id=@ficha[0].id
        @orc_empenho.ficha=@ficha[0].ficha

       @orc_empenho.save




   if session[:create_new_itens]== 1
   session[:create_new_itens]= 0
   end
   empenho=@orc_empenho.id
   @empenho = OrcEmpenho.find(:all, :conditions =>['id=?',empenho])
   if  session[:sem_si]==1
       @itens_compra = OrcPedidoDescricao.find(:all, :conditions => ["orc_pedido_compra_id =?" , session[:compra]])

          for item_compra in @itens_compra
              valor_item=item_compra.total
              session[:create_new_itens]=1
              @orc_empenho_item = OrcEmpenhoIten.new(params[empenho])
              @orc_empenho_item.orc_empenho_id = empenho
              @orc_empenho_item.quantidade = item_compra.quantidade
              @orc_empenho_item.descricao = item_compra.descricao
              @orc_empenho_item.unitario = item_compra.unitario
              @orc_empenho_item.total = item_compra.total
              @orc_empenho_item.total_geral = item_compra.total_geral
              session[:valor_total] = @orc_empenho_item.total_geral
              @orc_empenho_item.save
                       # salva items do empenho
              @orc_empenho.valor_total= session[:valor_total]
              @orc_empenho.save
                      # Atualiza saldo na ficha
             
           end


       session[:emp_id]= @empenho[0].id
       session[:sem_si]= 0
     end

        flash[:notice] = 'SALVO COM SUCESSO.'
        #format.html { redirect_to(new_itens_path) }
         format.html { redirect_to( {:action => "edit", :id =>@empenho[0].id} ) }
         format.html { redirect_to( @empenho) }
         format.xml  { render :xml =>  @empenho, :status => :created, :location =>  @empenho }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @orc_empenho.errors, :status => :unprocessable_entity }
      end
    end
    session[:created]= 1
  end





  # PUT /orc_empenhos/1
  # PUT /orc_empenhos/1.xml
  def update
    @orc_empenho = OrcEmpenho.find(params[:id])
    
     if session[:created]== 1
       @ficha = OrcFicha.find(:all, :conditions => ['id =?',  session[:ficha_id]])
       @itens_empenho = OrcEmpenhoIten.find(:all, :conditions => ["orc_empenho_id =?" , params[:id]])
       empenhado= @ficha[0].saldo_empenhado
       saldo = @ficha[0].saldo
          for item in @itens_empenho
              valor_item=item.total
                      # Atualiza saldo na ficha
              empenhado= empenhado + valor_item
              saldo = saldo - valor_item
           end
         @ficha[0].saldo = saldo
       @ficha[0].saldo_empenhado = empenhado
       t=0
       @ficha[0].save
     
       session[:created]= 0
     end

      if params[:cancela].to_i == 1
          @ficha = OrcFicha.find(:all, :conditions => ['id =?',  @orc_empenho.ficha_id])
               valor_empenho = @orc_empenho.valor_total
                      # Atualiza saldo na ficha

                empenho =@ficha[0].saldo_empenhado 
                saldo= @ficha[0].saldo
                @ficha[0].saldo_empenhado = empenho  - valor_empenho
                @ficha[0].saldo= saldo  + valor_empenho
                @ficha[0].save

                @orc_empenho.cancelado=1
                @orc_empenho.save

      end

    respond_to do |format|
      if @orc_empenho.update_attributes(params[:orc_empenho])
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@orc_empenho) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @orc_empenho.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orc_empenhos/1
  # DELETE /orc_empenhos/1.xml
  def destroy
       @orc_empenho = OrcEmpenho.find(params[:id])
       valor_empenho = @orc_empenho.valor_total
              # Atualiza saldo na ficha
        @ficha = OrcFicha.find(:all, :conditions => ['id =?', @orc_empenho.ficha_id])
        empenho =@ficha[0].saldo_empenhado 
        saldo= @ficha[0].saldo
        @ficha[0].saldo_empenhado = empenho  - valor_empenho
        @ficha[0].saldo= saldo  + valor_empenho
        @ficha[0].save
        @orc_empenho.destroy

    respond_to do |format|
      format.html { redirect_to(consulta_orc_empenhos_path) }
      format.xml  { head :ok }
    end
  end


  def dados_pedido
      session[:compra]= params[:orc_empenho_orc_pedido_compra_id]
     @orc_pedido_compra = OrcPedidoCompra.find(:all, :conditions => ["id =?" , params[:orc_empenho_orc_pedido_compra_id]])
      session[:ficha_id]=  @orc_pedido_compra[0].orc_ficha_id
     session[:sem_si]=1
     render :partial => "pedido"
  end


 def create_orc_empenho_item
   session[:create_new_itens]=1
   @orc_empenho_item = OrcEmpenhoIten.new(params[:orc_empenho_item])
      valor_item= @orc_empenho_item.total

      @orc_empenho_item.orc_empenho_id = session[:news_itens]
            # salva items do empenho
      if @orc_empenho_item.save
         @orc_empenho_itens=OrcEmpenhoIten.find(:all, :conditions =>['orc_empenho_id =?', session[:news_itens]])

        for item in @orc_empenho_itens
          
          session[:soma]=session[:soma].to_f+item.total.to_f
          item.total_geral=session[:soma].to_f
          session[:valor_total] = item.total_geral
          item_empenho_id = item.orc_empenho_id
          
          item.save
        end


          # salva valor_total no empenho
         @orc_empenho= OrcEmpenho.find(item_empenho_id)
         @orc_empenho.valor_total= session[:valor_total]

         @orc_empenho.save

          if session[:atualiza_ficha] == 1
             # Atualiza saldo na ficha
            @ficha = OrcFicha.find(:all, :conditions => ['id =?', @orc_empenho.ficha_id])

            empenhado= @ficha[0].saldo_empenhado
            saldo = @ficha[0].saldo
            @ficha[0].saldo_empenhado = empenhado + valor_item
            @ficha[0].saldo = saldo - valor_item
            @ficha[0].save
            session[:atualiza_ficha] = 0
          end


             # Atualiza pedido_compra
 #       @pedido = OrcPedidoCompra.find(:all, :conditions => ['id =?', @orc_empenho.orc_pedido_compra_id])
 #       @pedido[0].empenhado = 1
 #       @pedido[0].save



        render :update do |page|
          page.replace_html 'dados', :partial => "orc_empenho_itens"
          page.replace_html 'new'
        end
       end
  end


 
 def destroy_itens

#    @orc_pedido_descricao = OrcPedidoDescricao.find(params[:id])
    @orc_empenho_iten = OrcEmpenhoIten.find(params[:id])
    w= session[:id_empenho]= @orc_empenho_iten.orc_empenho_id
    valor_item = @orc_empenho_iten.total
    @empenho = OrcEmpenho.find(:all, :conditions => ['id = ?', session[:id_empenho]])
     if session[:atualiza_ficha] == 1
              # Atualiza saldo na ficha
            @ficha = OrcFicha.find(:all, :conditions => ['id =?', @empenho[0].ficha_id])
            empenhado= @ficha[0].saldo_empenhado
            saldo = @ficha[0].saldo
            @ficha[0].saldo_empenhado = empenhado - valor_item
            @ficha[0].saldo = saldo + valor_item
            @ficha[0].save
            session[:atualiza_ficha] = 0
     end
     @orc_empenho_iten.destroy
    # salva valor_total no empenho
    @orc_empenho_itens=OrcEmpenhoIten.find(:all, :conditions =>['orc_empenho_id =?', session[:id_empenho] ])
    for item in @orc_empenho_itens
          session[:soma]=session[:soma].to_f + item.total.to_f
          item.total_geral=session[:soma].to_f
          item.save
        end
        
     
     @empenho[0].valor_total= session[:soma].to_f
     @empenho[0].save


                    respond_to do |format|

                       flash[:notice] = 'ALTERADO COM SUCESSO.'
                                format.html { redirect_to( {:action => "edit", :id => @empenho[0].id} ) }
                                format.html { redirect_to( @empenho) }
                                format.xml  { render :xml =>  @empenho, :status => :created, :location =>  @empenho }
                end
    end


  def consulta_empenho
    if params[:type_of].to_i == 1   #fornecedor
         @empenhos = OrcEmpenho.find(:all,:conditions => ['id != 1 and interessado like ?', "%" + params[:search_fornecedor].to_s + "%"], :order => 'id DESC')
          render :update do |page|
                  page.replace_html 'empenho', :partial => "empenhos"
          end
    else if params[:type_of].to_i == 3   #sem ficha            produto(antigo)
                  @empenhos = OrcEmpenho.find(:all,:conditions => ['id != 1 and codigo like ?', "%" + params[:search_empenho].to_s + "%"], :order => 'id DESC')
               render :update do |page|
                  page.replace_html 'empenho', :partial => "empenhos"
               end
         else if params[:type_of].to_i == 4   #todas
                 @empenhos = OrcEmpenho.find(:all,:conditions => ['id != 1'], :order => 'id DESC')
               render :update do |page|
                  page.replace_html 'empenho', :partial => "empenhos"
               end
                 else if params[:type_of].to_i == 5   #dia
                            w=session[:dataI]=params[:empenho][:dataI][6,4]+'-'+params[:empenho][:dataI][3,2]+'-'+params[:empenho][:dataI][0,2]
                            w1=session[:dataF]=params[:empenho][:dataF][6,4]+'-'+params[:empenho][:dataF][3,2]+'-'+params[:empenho][:dataF][0,2]
                            e2=session[:mes]=params[:empenho][:dataF][3,2]
                             @empenhos = OrcEmpenho.find_by_sql("SELECT * FROM orc_empenhos WHERE (data_chegou BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"') GROUP BY id ORDER BY data DESC")
                         render :update do |page|
                            page.replace_html 'empenho', :partial => "empenhos"
                         end
                      end
                 end
          end
     end
  end

def ficha_empenho

  @empenhos = OrcEmpenho.find_by_sql('SELECT * FROM orc_empenhos WHERE ficha  IN (SELECT ficha FROM orc_fichas WHERE ficha = "'+params[:orc_empenho_ficha] +'") ORDER BY codigo ASC')

  render :partial => "empenhos"
end

 def dados_ficha
    session[:ficha_id] = params[:orc_empenho_ficha_id]
    @dados_ficha=  OrcFicha.find(:all, :conditions => ['ficha_id = ?',params[:orc_empenho_ficha_id]])
     session[:sem_si]=0
     render :partial => "dados_fichas"
end

end