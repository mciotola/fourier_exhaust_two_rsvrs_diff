puts "\n\n"
puts "###############################################################################"
puts "#                                                                             #"
puts "# FOURIER HEAT CONDUCTION LAW--EXHAUSTIBLE RESERVOIRS - DIFF version 01.11    #"
puts "#_____________________________________________________________________________#"
puts "#                                                                             #"
puts "# Copyright 2011-17 by Mark Ciotola; available for use under GNU license      #"
puts "# Created on 15 June 2014. Last revised on 10 May 2017                        #"
puts "#_____________________________________________________________________________#"
puts "#                                                                             #"
puts "# Description:                                                                #"
puts "# This simulation calculates the flow of heat energy across a thermal         #"
puts "# conductor that connects a warmer object to a cooler object.                 #"
puts "# Both reservoirs are exhaustible and can have different characteristics.     #"
puts "#                                                                             #"
puts "###############################################################################"
puts "\n\n"

      ###############################################################################
      #                                                                             #
      # Developed with Ruby 1.9.2, 2.2.4                                            #
      # Takes the following parameters: temperature of reservoirs                   #
      #                                 conductor material                          #
      #                                 conductor area                              #
	  #                                 conductor length                            #
	  #                                 hot and cold reservoir thermal energy       #
	  #                                 hot and cold reservoir volume               #
	  #                                 hot and cold reservoir specific heat        #
      #                                                                             #
      # Website: http://www.heatsuite.com                                           #
      # Source site: https://github.com/mciotola/fouriers_law_of_heat_conduction    #
      ###############################################################################


puts "================================== Background =================================\n\n"

  puts " Fourier's Law of Conduction describes the flow of thermal energy through     "
  puts " a conductor bridging a temperature difference. In this simulation the "
  puts " temperature difference can change with time."
  puts "\n"
  puts " dQ/dt = (k A ) (d T / d L) \n\n"
  puts "Where: \n\n"
  puts " Q = flow of thermal energy \n"
  puts " t = time \n"
  puts " A = area of conductor \n"
  puts " L = length of conductor \n"
  puts " T = temperature difference \n\n"
  
# INCLUDE LIBRARIES & SET-UP

  include Math
  require 'csv'
  prompt = "> "

  
# SET SIMULATION PARAMETERS

  periods = 201
  # warmertemp = 1000.0 # in K
  # coolertemp = 300.0 # in K
  conductor_material = 'copper' #'iron' 'wood'
  area = 1.0
  length = 200.0

  hotreservoirvolume = 100.0 # m^2
  coldreservoirvolume = 300.0 # m^2

  hotreservoirspecificheat = 1.0 # J/K?  or per m^3?
  coldreservoirspecificheat = 2.0 # J/K? or per m^3?

  hotreservoirsenergy = 100000.0 # J
  coldreservoirsenergy =  180000.0 # J


# Look-up material thermal conductivity

  if conductor_material == 'iron'
    thermalconductivity = 80.0
    elsif conductor_material == 'copper'
    thermalconductivity = 400.0
    elsif conductor_material == 'wood'
    thermalconductivity = 0.08
  end


# Initialize simulation variables

  time = 0 # s; this is an integer variable



  hottemp = hotreservoirsenergy / (hotreservoirvolume * hotreservoirspecificheat)
  coldtemp = coldreservoirsenergy / (coldreservoirvolume * coldreservoirspecificheat)

  entropyhot = hotreservoirsenergy/hottemp
  entropycold = coldreservoirsenergy/coldtemp

  tempdiff = hottemp - coldtemp
  heatenergyflow = ( (area * thermalconductivity) / length) * tempdiff

  cumenergyflow = 0.0
  entropyflowhot = 0.0
  entropyflowcold = 0.0
  entropychange = 0.0
  cumentropychange = 0.0

# optional output file
  puts "\n"
  puts "What is the desired name for your output file? [fourier_w_exhaust_two_rsvr.csv]:"
    print prompt
output_file = STDIN.gets.chomp()

if output_file > ""
    output_file = output_file
	else
    output_file = "fourier_two_ex_rsvr_diff.csv"
end

# target = File.open(output_file, 'w')

# Display the parameters

  puts "================================== Parameters =================================\n\n"

  puts sprintf "  Hot temp (in K): \t\t %7.3f " , hottemp.to_s
  puts sprintf "  Cold temp (in K): \t\t %7.3f " , coldtemp.to_s
  puts sprintf "  Thermal conductivity: \t %7.3f %s" , thermalconductivity.to_s, " in Watts/meter/Kelvin"
  puts sprintf "  Area (in m^2): \t\t %7.3f " , area.to_s
  puts sprintf "  Length (in m): \t\t %7.3f " , length.to_s
  puts sprintf "  Conductor Material: \t\t %7s " , conductor_material
  puts "\n\n"  


# Simulation Banner

  puts "\n\n"
  puts "RESULTS: \n\n"

  puts "TIME \tT hot \tT cold\tDiff  \tE Flow \tCumlFlow\tS hot \tS cold \tS Chng\tS Cum Chng"
  puts "-----\t------\t------\t------\t-------\t--------\t------\t-------\t-------\t----------\n"


# Run the simulation

  while time < periods
    if coldtemp < hottemp
        
        # Display variable short names
        
        t = time
        hott = hottemp
        coldt = coldtemp
        tdiff = tempdiff
        hef = heatenergyflow
        cumef = cumenergyflow
        shot = entropyhot
        scold = entropycold
        sfhot = entropyflowhot
        sfcold = entropyflowcold
        sc = entropychange
        cumsc = cumentropychange
        
        # Display the output
        
        # OMIT HOLISTICS ENTROPY CALC FOR EACH RESERVOIR, JUST DO DIFFERENCES;
        # THIS IS ONLY APPROXIMATELY LINEAR.
        
        
        mystring = ("%3d\t%6.2f\t%6.2f\t%6.2f\t%7.2f\t%8.2f\t%6.2f\t%7.2f\t%7.2f\t%10.2f")
        puts sprintf mystring, t.to_s, hott.to_s, coldt.to_s, tdiff.to_s, hef.to_s, cumef.to_s, sfhot.to_s, sfcold.to_s, sc.to_s, cumsc.to_s
        
        # Write to Output File
        periodstring = t.to_s+"\t"+hott.to_s+"\t"+coldt.to_s+"\t"+tdiff.to_s+"\t"+hef.to_s+"\t"+cumef.to_s+"\t"+sfhot.to_s+"\t"+sfcold.to_s+"\t"+sc.to_s+"\t"+cumsc.to_s
        
        
        CSV.open(output_file, "a+") do |csv|
            csv << [t.to_s, hott.to_s, coldt.to_s, hef.to_s]
        end

            
      tempdiff = hottemp - coldtemp
      heatenergyflow = ( (area * thermalconductivity) / length) * tempdiff

      cumenergyflow = cumenergyflow + heatenergyflow

      hotreservoirsenergy = hotreservoirsenergy - heatenergyflow
      coldreservoirsenergy = coldreservoirsenergy + heatenergyflow
  
      hottemp = hotreservoirsenergy / (hotreservoirvolume * hotreservoirspecificheat)
      coldtemp = coldreservoirsenergy / (coldreservoirvolume * coldreservoirspecificheat)
  
      entropyhot = hotreservoirsenergy/hottemp
      entropycold = coldreservoirsenergy/coldtemp
  
      entropyflowhot = - heatenergyflow/hottemp
      entropyflowcold = heatenergyflow/coldtemp
  
      entropychange = entropyflowhot + entropyflowcold
  
      cumentropychange = cumentropychange + entropychange


      time = time + 1
    
    end

  end

puts "\nSimulation is completed. \n\n"


# END MATTER

# Display key and references

  puts "\n\n"
  puts "\n\n"

  puts "================================== Units Key ==================================\n\n"
  puts "  Abbreviation: \t\t Unit:"
  puts "\n"
  puts "       J \t\t\t Joules, a unit of energy"
  puts "       K \t\t\t Kelvin, a unit of temperature"
  puts "       m \t\t\t meters, a unit of length"
  puts "       s \t\t\t seconds, a unit of time"
  puts "\n\n"


  puts "================================== References =================================\n\n"
  puts "Daniel V. Schroeder, 2000, \"An Introduction to Thermal Physics.\""
  puts "\n\n"

# Table of thermal conductivities (Watts/meter/Kelvin)

  # Conductor Material	Thermal Conductivity
  # air				      0.026
  # wood			      0.08
  # water		    	  0.6
  # iron		    	 80
  # copper		    	400
