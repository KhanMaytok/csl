class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def to_name_i(insured)
  	insured.paternal.to_s + " " + insured.maternal.to_s + " " + insured.name.to_s
  end

  def current_ability
    @current_ability ||= Ability.new(current_employee)
  end


  def coverage_type_stadistic(month)
    Coverage.joins(:authorization, :sub_coverage_type => :coverage_type).group('coverage_types.name').where('month(authorizations.date) =' << month).count
  end

  def get_active_facturation(site,position)
    if site == position
      ' list-group-item-info'
    else
      ''
    end
  end

  def render_error(status)
    respond_to do |format|
      format.html { render '/public/404.html'}
      format.all { render :nothing => true, :status => status }
    end
  end

  def to_name_h(insured)
  	insured.hold_paternal + " " + insured.hold_maternal + " " + insured.hold_name
  end

  def to_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.id
    end
    hash
  end

  def time_name(date)
   day = get_day(date.strftime('%w')).to_s
   month = get_month(date.strftime('%m')).to_s
   number_day = date.strftime('%d').to_s
   year = date.strftime('%Y').to_s
   return day + ', ' + number_day + ' de ' + month + ' del ' + year
  end

  def get_day(number)
    case number
    when '0'
      'Domingo'
    when '1'
      'Lunes'
    when '2'
      'Martes'
    when '3'
      'Miércoles'
    when '4'
      'Jueves'
    when '5'
      'Viernes'
    when '6'
      'Sábado'
    end
  end

  def get_month(number)
    case number
    when '01'
      'Enero'
    when '02'
      'Febrero'
    when '03'
      'Marzo'
    when '04'
      'Abril'
    when '05'
      'Mayo'
    when '06'
      'Junio'
    when '07'
      'Julio'
    when '08'
      'Agosto'
    when '09'
      'Septiembre'
    when '10'
      'Octubre'
    when '11'
      'Noviembre'
    when '12'
      'Diciembre'
    end
  end

  def date_time(date_object)
    date_object.strftime('%Y-%m-%d') + ' ' + date_object.strftime('%H:%M:%S')
  end
  def date(date_object)
    if date_object.nil?
      nil
    else
      date_object.strftime('%Y-%m-%d')
    end    
  end

  def colon(number)
    if number.length > 6
      number = number[0, number.length-6] + "," + number[-6,6]
    end
    return number
  end

  def new_capitalize(string)
    
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

  helper_method :get_active_facturation, :coverage_type_stadistic, :time_name,:datetime, :date, :colon, :to_name_i, :to_name_h, :age, :active, :current_employee, :is_loged?, :number_to_words
end
