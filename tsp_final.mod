# Sets
param N := 12;

set Cities;
set Edges within {Cities, Cities};

param dist{Cities, Cities};

# Parameters
# param Distance{i in Cities, j in Cities} >= 0;

set selectedCitiesIndex := {2..N+1};
set subtourIndex :={3..N+1};

param selected_distances{i in selectedCitiesIndex, j in selectedCitiesIndex : i <> j} := dist[i, j];


# Decision Variables
var x{i in selectedCitiesIndex, j in selectedCitiesIndex} binary;
var u{selectedCitiesIndex} integer >= 2, <= N;


# Objective Function
minimize TotalDistance: sum{i in selectedCitiesIndex, j in selectedCitiesIndex: i <> j} selected_distances[i, j] * x[i, j];

# Constraints
subject to TourOut{i in selectedCitiesIndex}: sum{j in selectedCitiesIndex : i <> j} x[i, j] = 1;
subject to TourIn{j in selectedCitiesIndex}: sum{i in selectedCitiesIndex : i <> j} x[i, j] = 1;

# Subtour Elimination
subject to SubtourElimination{i in subtourIndex, j in subtourIndex: i <> j}:
    u[i] - u[j] + (N - 1) * x[i, j] <= N - 2;

/* subject to SubtourElimination{i in selectedCitiesIndex: i <> 1}:
    sum{j in selectedCitiesIndex: j <> i} sum{k in selectedCitiesIndex: k <> i, k <> j} x[i, j] + sum{j in selectedCitiesIndex: j <> i} sum{k in selectedCitiesIndex: k <> i, k <> j} x[k, i] >= 2;*/

# Solve
solve;

# Display Results
printf "Optimal Tour: ";
for {i in selectedCitiesIndex}
    for {j in selectedCitiesIndex: j <> i}
        for {{0}: x[i, j] > 0.5} {
            printf "%d -> %d ", i, j;
        }

printf "\n";

printf "Total Distance: %g\n", TotalDistance;

data datafile;