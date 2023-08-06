using Random

# Genetic Algorithm Parameters
population_size = 50
target_string = "HELLO, JULIA!"
mutation_rate = 0.01
max_generations = 1000

# Generate initial population of random binary strings
function generate_population(size, length)
    population = []
    for _ in 1:size
        individual = [rand(Bool) for _ in 1:length]
        push!(population, individual)
    end
    return population
end

# Calculate fitness of an individual
function calculate_fitness(individual, target)
    fitness = sum([ind == tgt for (ind, tgt) in zip(individual, target)])
    return fitness
end

# Select parents using tournament selection
function select_parents(population, target)
    parents = []
    for _ in 1:2
        tournament = sample(population, 5, replace=false)
        winner = argmax([calculate_fitness(ind, target) for ind in tournament])
        push!(parents, tournament[winner])
    end
    return parents
end

# Crossover to create a new child
function crossover(parent1, parent2)
    crossover_point = rand(2:length(parent1)-1)
    child = vcat(parent1[1:crossover_point], parent2[crossover_point+1:end])
    return child
end

# Mutate an individual
function mutate(individual, rate)
    for i in 1:length(individual)
        if rand() < rate
            individual[i] = !individual[i]
        end
    end
    return individual
end

# Main genetic algorithm loop
function genetic_algorithm(target, population_size, mutation_rate, max_generations)
    population = generate_population(population_size, length(target))
    generation = 1
    
    while generation <= max_generations
        population = sort(population, by=ind -> -calculate_fitness(ind, target))
        best_individual = population[1]
        best_fitness = calculate_fitness(best_individual, target)
        
        println("Generation $generation: $best_individual (Fitness: $best_fitness)")
        
        if best_fitness == length(target)
            println("Target string achieved!")
            break
        end
        
        new_population = []
        while length(new_population) < population_size
            parents = select_parents(population, target)
            child = crossover(parents[1], parents[2])
            mutated_child = mutate(child, mutation_rate)
            push!(new_population, mutated_child)
        end
        
        population = new_population
        generation += 1
    end
end

# Run the genetic algorithm
Random.seed!(123)  # For reproducibility
genetic_algorithm(collect(target_string), population_size, mutation_rate, max_generations)
