[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 15
  xmax = .005
  ymax = .005
  elem_type = QUAD4
[]

[Variables]
  active = 'T'
  [./T]
  [../]
  [./u]
  [../]
  [./phi]
  [../]
[]

[AuxVariables]
  active = 'phi'
  [./phi]
  [../]
  [./u]
  [../]
  [./T]
  [../]
[]

[Kernels]
  active = 'heat_diffusion heat_phi_time heat_time'
  [./heat_diffusion]
    type = PikaDiffusion
    variable = T
    use_temporal_scaling = true
    property = conductivity
  [../]
  [./heat_time]
    type = PikaTimeDerivative
    variable = T
    property = heat_capacity
    scale = 1.0
  [../]
  [./heat_phi_time]
    type = PikaCoupledTimeDerivative
    variable = T
    property = latent_heat
    scale = -0.5
    use_temporal_scaling = true
    coupled_variable = phi
  [../]
  [./vapor_time]
    type = PikaTimeDerivative
    variable = u
    coefficient = 1.0
    scale = 1.0
  [../]
  [./vapor_diffusion]
    type = PikaDiffusion
    variable = u
    property = diffusion_coefficient
    use_temporal_scaling = true
  [../]
  [./vapor_phi_time]
    type = PikaCoupledTimeDerivative
    variable = u
    coefficient = 0.5
    coupled_variable = phi
    use_temporal_scaling = true
  [../]
  [./phi_time]
    type = PikaTimeDerivative
    variable = phi
    property = tau
    scale = 1.0
  [../]
  [./phi_transition]
    type = PhaseTransition
    variable = phi
    mob_name = mobility
    chemical_potential = u
  [../]
  [./phi_double_well]
    type = DoubleWellPotential
    variable = phi
    mob_name = mobility
  [../]
  [./phi_square_gradient]
    type = ACInterface
    variable = phi
    mob_name = mobility
    kappa_name = interface_thickness_squared
  [../]
[]

[BCs]
  active = 'T_hot T_cold'
  [./T_hot]
    type = DirichletBC
    variable = T
    boundary = bottom
    value = 267.515 # -5
  [../]
  [./T_cold]
    type = DirichletBC
    variable = T
    boundary = top
    value = 264.8 # -20
  [../]
  [./insulated_sides]
    type = NeumannBC
    variable = T
    boundary = 'left right'
  [../]
  [./phi_bc]
    type = DirichletBC
    variable = phi
    boundary = '0 1 2 3 '
    value = 1.0
  [../]
  [./u_bottom]
    type = DirichletBC
    variable = u
    boundary = bottom
    value = -4.7e-6
  [../]
  [./u_top]
    type = DirichletBC
    variable = u
    boundary = top
    value = 4.7e-6
  [../]
[]

[Postprocessors]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  num_steps = 5
  dt = 10000
  solve_type = PJFNK
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  petsc_options_value = '500 hypre boomeramg'
[]

[Adaptivity]
  max_h_level = 4
  initial_steps = 4
  marker = phi_marker
  initial_marker = phi_marker
  [./Indicators]
    [./phi_jump]
      type = GradientJumpIndicator
      variable = phi
    [../]
  [../]
  [./Markers]
    [./phi_marker]
      type = ErrorFractionMarker
      coarsen = .12
      indicator = phi_jump
      refine = .6
    [../]
  [../]
[]

[Outputs]
  active = 'console'
  output_initial = true
  exodus = true
  file_base = temp_diffusion
  output_intermediate = false
  output_final = true
  xdr = true
  [./console]
    type = Console
    perf_log = true
    linear_residuals = true
  [../]
  [./exodus]
    file_base = temp_diffusion
    type = Exodus
  [../]
  [./results_for_initial]
    num_files = 1
    output_input = true
    file_base = temp_initial
    type = Checkpoint
  [../]
[]

[ICs]
  active = 'phase_ic temperature_ic'
  [./phase_ic]
    x1 = .0025
    y1 = .0025
    radius = 0.0005
    outvalue = 1
    variable = phi
    invalue = -1
    type = SmoothCircleIC
    int_width = 5e-5
  [../]
  [./temperature_ic]
    variable = T
    type = FunctionIC
    function = -543.0*y+267.515
  [../]
  [./vapor_ic]
    variable = u
    type = ChemicalPotentialIC
    phase_variable = phi
    temperature = T
  [../]
  [./constant_temp_ic]
    variable = T
    type = ConstantIC
    value = 264.8
  [../]
  [./vapor_function_ic]
    function = -4.7e-6+0.00188*y
    variable = u
    type = FunctionIC
    block = 0
  [../]
[]

[PikaMaterials]
  phi = phi
  temperature = T
  interface_thickness = 1e-5
  temporal_scaling = 1e-4
  output_properties = diffusion_coefficient
  outputs = all
[]

