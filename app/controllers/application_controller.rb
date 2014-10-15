class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def to_name_i(insured)
  	insured.name+ " " + insured.paternal + " " + insured.maternal
  end

  def to_name_h(insured)
  	insured.hold_name+ " " + insured.hold_paternal + " " + insured.hold_maternal
  end

  def to_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.id
    end
    hash
  end

  def get_time
    return Time.now.to_i
  end

  def active(controller)    
      if controller == params[:controller]
        'class=active'
      end
  end

  def age(birthday)
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def current_employee
    @employee = Employee.find(session[:id])
  end

  def is_loged?
    !!session[:status]
  end

  def block_unloged
    if !session[:status]
      redirect_to security_path
    end
  end

  def to_words(numero)
    de_tres_en_tres = numero.to_i.to_s.reverse.scan(/\d{1,3}/).map{|n| n.reverse.to_i}
 
    millones = [
      {true => nil, false => nil},
      {true => 'millón', false => 'millones'},
      {true => "billón", false => "billones"},
      {true => "trillón", false => "trillones"}
    ]
 
    centena_anterior = 0
    contador = -1
    palabras = de_tres_en_tres.map do |numeros|
      contador += 1
      if contador%2 == 0
        centena_anterior = numeros
        [centena_a_palabras(numeros), millones[contador/2][numeros==1]].compact if numeros > 0
      elsif centena_anterior == 0
        [centena_a_palabras(numeros), "mil", millones[contador/2][false]].compact if numeros > 0
      else
        [centena_a_palabras(numeros), "mil"] if numeros > 0
      end
    end 
    palabras.compact.reverse.join(' ')
  end
 
  def centena_a_palabras(numero)
    especiales = {
      11 => 'once', 12 => 'doce', 13 => 'trece', 14 => 'catorce', 15 => 'quince',
      10 => 'diez', 20 => 'veinte', 100 => 'cien'
    }
    if especiales.has_key?(numero)
      return especiales[numero]
    end
   
    centenas = [nil, 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos', 'seiscientos', 'setecientos', 'ochocientos', 'novecientos']
    decenas = [nil, 'dieci', 'veinti', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta', 'noventa']
    unidades = [nil, 'un', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve']
   
    centena, decena, unidad = numero.to_s.rjust(3,'0').scan(/\d/).map{|i| i.to_i}
   
    palabras = []
    palabras << centenas[centena]
   
    if especiales.has_key?(decena*10 + unidad)
      palabras << especiales[decena*10 + unidad]
    else
      tmp = "#{decenas[decena]}#{' y ' if decena > 2 && unidad > 0}#{unidades[unidad]}"
      palabras << (tmp.blank? ? nil : tmp)
    end 
    palabras.compact.join(' ')
  end

  helper_method :to_name_i, :to_name_h, :age, :active, :current_employee, :is_loged?, :number_to_words
end
