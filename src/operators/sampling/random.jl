struct RandomInBounds <: AbstractInitializer
    N::Int
end

"""
    RandomInBounds

Initialize `N` solutions with random values in bounds. Suitable for
integer and real coded problems.
"""
RandomInBounds(;N = 0) = RandomInBounds(N)


sample(method::RandomInBounds, bounds) = _scale_sample(rand(method.N, size(bounds,2)), bounds)

"""
    RandomBinary(;N)

Create random binary individuals.
"""
struct RandomBinary <: AbstractInitializer
    N::Int
    RandomInBounds(;N = 0) = new(N)
end




"""
    RandomPermutation(;N)

Create individuals in random permutations.
"""
struct RandomPermutation <: AbstractInitializer
    N::Int
    RandomPermutation(;N = 0) = new(N)
end

function gen_initial_state(problem,parameters::RandomPermutation,information,options)

    D = getdim(problem)
    X = zeros(Int, parameters.N, D)
    N = parameters.N
    for i in 1:parameters.N
        X[i,:] = shuffle(1:D)
    end

    if problem.parallel_evaluation
        population = create_solutions(X, problem; ε=options.h_tol)
    else
        population = [ create_solution(X[i,:], problem; ε=options.h_tol) for i in 1:N]
    end 

    best_solution = get_best(population)

    State(best_solution, population; f_calls = length(population), iteration=1)
end
