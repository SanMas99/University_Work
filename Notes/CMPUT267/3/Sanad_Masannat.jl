### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ dc004086-db6e-4813-841e-d427520402f7
begin
	using CSV, DataFrames, Random
	using PlutoUI
	using PlotlyJS
	import Colors: Colors, @colorant_str
	using LinearAlgebra: dot, norm, norm1, norm2, I
	using Distributions: Distributions, Uniform
	using Statistics
	using MultivariateStats: MultivariateStats, PCA
	using StatsBase: StatsBase
end

# ╔═╡ 75441ce6-2137-4fcf-bba2-6ed67b9acb59
begin
	_check_complete(complete) = complete ? "✅" : "❌"
	
	md"""
	# Setup

	this section loads and installs all the packages. You should be setup already from assignment 1, but if not please read and follow the `instructions.md` for further details.
	"""
end

# ╔═╡ 6123f99e-bbfd-4e5c-aba8-fb0cc67b923d
PlutoUI.TableOfContents(title="A3 Outline")

# ╔═╡ 693a3933-c1c2-4249-8c03-f5151267222f
md"""
### !!!IMPORTANT!!!

Insert your details below. You should see a green checkmark.
"""

# ╔═╡ def97306-1703-42bc-bc09-da623c545e87
student = (
	name="Sanad Masannat", 
	email="sanad@ualberta.ca", 
	ccid="sanad", 
	idnumber=1626221
)

# ╔═╡ bc0c5abe-1c2a-4e5c-bb0c-8d76b5e81133
let
	def_student = (name="NAME as in eclass", email="UofA Email", ccid="CCID", idnumber=0)
	if length(keys(def_student) ∩ keys(student)) != length(keys(def_student))
		md"You don't have all the right entries! Make sure you have `name`, `email`, `ccid`, `idnumber`. ❌"
	elseif any(getfield(def_student, k) == getfield(student, k) for k in keys(def_student))
		md"You haven't filled in all your details! ❌"
	elseif !all(typeof(getfield(def_student, k)) === typeof(getfield(student, k)) for k in keys(def_student))
		md"Your types seem to be off: `name::String`, `email::String`, `ccid::String`, `idnumber::Int`"
	else
		md"Welcome $(student.name)! ✅"
	end
end

# ╔═╡ 14c30b50-157f-40bf-b0a6-0232aa2705c6
md"""
Important Note: You should only write code in the cells that has: """


# ╔═╡ 4a196e82-fe94-49fe-ab87-d57e2d7fbd34
#### BEGIN SOLUTION


#### END SOLUTION

# ╔═╡ fc673678-945c-4ec3-8c2a-47eacbe00492
function check_elements(Φ_true::Matrix{Float64}, Φ::Matrix{Float64})
	all_exist = true
	for n in eachindex(Φ_true), m in eachindex(Φ_true[n])
		if Φ_true[n][m] ∉ Φ || Φ[n][m] ∉ Φ_true
			has_sim = false
			for i in eachindex(Φ_true), j in eachindex(Φ_true[i])
				if Φ_true[i][j] ≈ Φ[n][m]
					has_sim = true
				end 
			end 
			true_has_sim = false
			for i in eachindex(Φ), j in eachindex(Φ[i])
				if Φ[i][j] ≈ Φ_true[n][m]
					true_has_sim = true
				end 
			end 
			if has_sim == false || true_has_sim == false
				all_exist = false
			end
		end
	end
	all_exist
end 


# ╔═╡ a7aecd21-13f2-4cf2-8239-3a3d708602c9
md"""
# Q2: Multi-variate Regression

In the last assignment you learned the weight for a simplistic univariate setting, to predict y from x. Now we get to move to the multivariate setting! This means more than one input, which is a much more realistic problem setting.

Unlike before, instead of having a struct be all the properties of an ML systems we will break our systems into smaller pieces. This will allow us to more easily take advantage of code we've already written, and will be more useful as we expand the number of algorithms we consider. We make several assumptions to simplify the code, but the general type hierarchy can be used much more broadly.

We split each system into:
- Model
- Gradient Descent Procedure
- Loss Function
- Optimization Strategy
"""

# ╔═╡ e3c3e903-e2c2-4de0-a3b2-56a27709e8c3
md"""
## Baselines
"""

# ╔═╡ 3237c4fc-56d1-4135-a8d2-cc6e88f2f5c0
md"""
### Mean Model
"""

# ╔═╡ a35944ae-7bbb-4f3c-bbe0-d2bbb57cd70b
md"""
### RandomModel
"""

# ╔═╡ 4f4029a2-c590-4bd3-a0db-d2380d4b4620
md"""
## Models

- `AbstractModel`: This is an abstract type which is used to derive all the model types in this assignment
- `predict`: This takes a matrix of samples and returns the prediction doing the proper data transforms.
- `get_features`: This transforms the features according to the non-linear transform of the model (which is the identity for linear).
- `get_linear_model`: All models are based on a linear model with transformed features, and thus have a linear model.
- `copy`: This returns a new copy of the model.
"""

# ╔═╡ dcfecc35-f25c-4856-8429-5c31d94d0a42
"""
	AbstractModel

Used as the root for all models in this notebook. We provide a helper `predict` function for `AbstractVectors` which transposes the features to a row vector. We also provide a default `update_transform!` which does nothing.
"""
abstract type AbstractModel end

# ╔═╡ d45dedf8-e46a-4ffb-ab45-f9d211d3a8ca
predict(alm::AbstractModel, x::AbstractVector) = predict(alm, x')[1]

# ╔═╡ 7cd46d84-a74c-44dc-8339-68010924bc39
update_transform!(AbstractModel, args...) = nothing

# ╔═╡ 8745fec1-47c8-428b-9ea4-1e6828618830
md"
### Linear Model

A linear model is the linear function
```math
f(x) = \mathbf{x}^\top\mathbf{w}
```
giving us a prediction $$\hat{y}$$.

Note that to query this function on more than one sample, we can use the fact that $$\mathbf{X} \mathbf{w}$$ corresponds to a vector where the first element is the dot product between the first row of $$\mathbf{X}$$ and $$\mathbf{w}$$, the second element is the dot product between the second row of $$\mathbf{X}$$ and $$\mathbf{w}$$ and so on. We exploit this in `predict`, to return predictions for the data matrix $$\mathbf{X}$$ of size `(samples, features)`.

We define `get_features`, which we will need for polynomial regression. For linear regression, the default is to return the inputs themselves. In polynomial regression, we will replace this function with one that returns polynomial features.

"

# ╔═╡ 2d43a3ba-2a2c-4114-882f-5834d42e302a
begin
	struct LinearModel <: AbstractModel
		w::Matrix{Float64} # Aliased to Array{Float64, 2}
	end
	
	LinearModel(in, out=1) = 
		LinearModel(zeros(in, out)) # feature size × output size
	
	Base.copy(lm::LinearModel) = LinearModel(copy(lm.w))
	predict(lm::LinearModel, X::AbstractMatrix) = X * lm.w
	get_features(m::LinearModel, x) = x

end

# ╔═╡ fbbcda71-43a2-4484-87b5-05a81d2101e7
md"""
 
For this notebook we use minibatch gradient descent, and three stepsize approaches: `ConstantLR`, `HeuristicLR`, and `AdaGrad`. We provide a default update function below, that does gradient descent with a stepsize of 1.0. This update function will be defined for each of these three stepsize approaches later. 

Notice that we use `.-=` which is the same as `lm.w = lm.w .- Δw`. The dot-minus means elementwise subtraction, for the vectors `lm.w` and `Δw`. In general, prefacing with a dot means elementwise operations: `a.*b` would mean elementwise product between vectors `a` and `b`, and `a./b` would mean elementwise division.  

"""

# ╔═╡ d9935cc8-ec24-47e9-b39a-92c21377a161
struct MiniBatchGD
	n::Int
end

# ╔═╡ 5080cc19-d13f-4236-b49e-e338108dda80
begin
	"""
		MeanModel()
		
	Predicts the mean value of the regression targets passed in through `epoch!`.
	"""
	mutable struct MeanModel <: AbstractModel
		μ::Float64
	end
	MeanModel() = MeanModel(0.0)
	predict(reg::MeanModel, X::AbstractVector) = reg.μ
	predict(reg::MeanModel, X::AbstractMatrix) = fill(reg.μ, size(X,1))
	Base.copy(reg::MeanModel) = MeanModel(reg.μ)
	function train!(::MiniBatchGD, model::MeanModel, lossfunc, opt, X, Y, num_epochs)
		model.μ = mean(Y)
	end
end

# ╔═╡ e7712bd3-ea7e-4f4a-9efc-041b4b2be987
begin
	"""
		RandomModel
	
	Predicts `b*x` where `b` is sambled from a normal distribution.
	"""
	struct RandomModel <: AbstractModel # random weights
		w::Matrix{Float64}
	end
	RandomModel(in, out) = RandomModel(randn(in, out))
	predict(reg::RandomModel, X::AbstractMatrix) = X*reg.w
	Base.copy(reg::RandomModel) = RandomModel(randn(size(reg.w)...))
	train!(::MiniBatchGD, model::RandomModel, lossfunc, opt, X, Y, num_epochs) = 
		nothing
end

# ╔═╡ 5714c84f-1653-4c4a-a2e4-003d8560484a
md"""
 
First, you will set up the basic minibatch gradient descent code. You need to implement the function `epoch!` which goes through the data set in minibatches of size `mbgd.n`. Remember to shuffle the data for each epoch. In your code, you can call the function 

```julia
update!(model, lossfunc, opt, X_batch, Y_batch)
```

to update your model in the epoch. Again, we will use different updates depending on the stepsize rules, defined in the section below on [optimizers](#opt).

"""

# ╔═╡ a17e5acd-d78d-4fab-9ab2-f01bd888339d
HTML("<h2 id=lossfunc> Loss Functions  </h2>")

# ╔═╡ 7e777dba-b389-4549-a93a-9b0394646c57
abstract type LossFunction end

# ╔═╡ 6d2d24da-9f3f-43df-9243-fc17f85e0b01
md"""
We will be implementing 1/2 MSE in the loss function.

```math
c(\mathbf{w}) = \frac{1}{2n} \sum_i^n (f(\mathbf{x}_i) - y_i)^2
```

where $f(\mathbf{x})$ is the prediction from the passed model.
"""

# ╔═╡ 4f43373d-42ee-4269-9862-f53695351ea3
struct MSE <: LossFunction end

# ╔═╡ 4ea14063-99ca-4caf-a862-fbf9590c68a2
md"""
You will implement the gradient of the MSE loss function `c(w)` in the `gradient` function with respect to `w`, returning a matrix of the same size of `lm.w`.
"""

# ╔═╡ 299116ea-66f3-4e52-ab0f-594249b9dd23
function gradient(lm::AbstractModel, mse::MSE, X::Matrix, Y::Vector)
	∇w = zero(lm.w) # gradients should be the size of the weights
	
	#### BEGIN SOLUTION
	n=length(Y)
	XT=X'
	sum=zero(lm.w)
	for i in 1:n
		sum.+=((X[i,:].* lm.w) .- Y[i]) .* X[i,:]
	end
	sum./=n
	∇w=sum
	#### END SOLUTION
	@assert size(∇w) == size(lm.w)
	∇w
end

# ╔═╡ af8acfdf-32bd-43c1-82d0-99008ee4cb3e
HTML("<h2 id=opt> Optimizers </h2>")

# ╔═╡ 36c1f5c8-ac43-41ea-9100-8f85c1ee3708
abstract type Optimizer end

# ╔═╡ 0f6929b6-d869-4c3c-90f6-c923b265b164
struct ConstantLR <: Optimizer
	η::Float64
end

# ╔═╡ 8b8fd9b8-a41b-4fef-96b7-a146986c6f82
Base.copy(clr::ConstantLR) = ConstantLR(clr.η)

# ╔═╡ 695d7dea-c398-43dd-a342-c204c050477e
begin
	mutable struct HeuristicLR <: Optimizer
		g_bar::Float64
	end
	HeuristicLR() = HeuristicLR(1.0)
end

# ╔═╡ 7a4f745a-cb65-49d0-80fa-0e67a75df2c1
Base.copy(hlr::HeuristicLR) = HeuristicLR(hlr.g_bar)

# ╔═╡ 77cda37c-c560-42d8-85b1-7f026d09edfe
md"""
AdaGrad is another technique for adapting the stepsize where we use a different stepsize for every element $$j$$ in the weight vector.

To implement the AdaGrad optimizer, we use the following equations for each $$j$$ from 1 to the length of the weight vector:

```math
\begin{align}
\bar{g}_{t,j} &= \bar{g}_{t-1,j} + g_j^2 \\
w_{t,j} &= w_{t-1,j} - \frac{\eta}{\sqrt{\bar{g}_{t,j} + \epsilon}} g_j
\end{align}
```
where $g$ is the gradient and $g_j$ is the $j$th element of the gradient. These equations can be implemented without using a for loop, by using elementwise multiplication and division. If you are stuck on the syntax, feel free to use a for loop. Note that to get the elementwise squaring of gradient $g$, you would use `g.^2` and to get elementwise sqrt you would use `sqrt.(g)`.

Implement ```AdaGrad```.
"""

# ╔═╡ ded749bf-b9fa-4e2b-b15f-0693d820a9c3
md"""
Now, we will implement Polynomial Model which uses the linear model on non-linear features. To do so, we apply a polynomial transformation to our data to create new polynomial features. For $d$ inputs with a polynomial of size $p$, the number of features is $m = {d+p \choose p}$, giving polynomial function 

```math
f(\mathbf{x})=\sum_{j=1}^{m} w_j \phi_j (\mathbf{x}) = \boldsymbol{\phi}(\mathbf{x})^\top\mathbf{w}
```
We simply apply this transformation to every data point $\mathbf{x}_i$ to get the new dataset $\{(\boldsymbol{\phi}(\mathbf{x}_i), y_i)\}$.

Implement the polynomial feature transformation for $p = 2$ degrees in the function ```get_features```.

"""

# ╔═╡ 2e69a549-aab4-4c88-aad8-dffb822d644f
begin
	struct Polynomial2Model <: AbstractModel 
		model::LinearModel
		ignore_first::Bool
	end
	Polynomial2Model(in, out=1; ignore_first=false) = if ignore_first
		in = in - 1
		Polynomial2Model(LinearModel(1 + in + Int(in*(in+1)/2), out), ignore_first)
	else
		Polynomial2Model(LinearModel(1 + in + Int(in*(in+1)/2), out), ignore_first)
	end
	Base.copy(lm::Polynomial2Model) = Polynomial2Model(copy(lm.model), lm.ignore_first)
	get_linear_model(lm::Polynomial2Model) = lm.model
	
end

# ╔═╡ 1fe7084a-9cf9-48a4-9e60-b712365eded9
begin
	mutable struct AdaGrad <: Optimizer
		η::Float64 # step size
		gbar::Matrix{Float64} # exponential decaying average
		ϵ::Float64 #
	end
	
	AdaGrad(η) = AdaGrad(η, zeros(1, 1), 1e-5)
	AdaGrad(η, lm::LinearModel) = AdaGrad(η, zero(lm.w), 1e-5)
	AdaGrad(η, lm::AbstractModel) = AdaGrad(η, get_linear_model(model))
	Base.copy(adagrad::AdaGrad) = AdaGrad(adagrad.η, zero(adagrad.gbar), adagrad.ϵ)
end

# ╔═╡ 0ba5f9c8-5677-40e9-811b-25546e0df207
function get_features(pm::Polynomial2Model, _X::AbstractMatrix)
	
	# If _X already has a bias remove it.
	X = if pm.ignore_first
		_X[:, 2:end]
	else
		_X
	end
	
	d = size(X, 2)
	N = size(X, 1)
	num_features = 1 + # Bias bit
				   d + # p = 1
				   Int(d*(d+1)/2) # combinations (i.e. x_i*x_j)
	
	Φ = zeros(N, num_features)
	
	# Construct Φ
	#### BEGIN SOLUTION
	i1=zeros(N)
	i2=zeros(N)
	i3=zeros(N)
	i4=zeros(N)
	i5=zeros(N)
	i6=zeros(N)
	for i in 1:N
		i1[i]=1
		i2[i]=X[i,1]
		i3[i]=X[i,2]
		i4[i]=i2[i]*i3[i]
		i5[i]=i2[i]^2
		i6[i]=i3[i]^2
	end
	Φ[:,1]=i1
	Φ[:,2]=i2
	Φ[:,3]=i3
	Φ[:,4]=i4
	Φ[:,5]=i5
	Φ[:,6]=i6
	
	#### END SOLUTION
	
	Φ
end

# ╔═╡ 159cecd9-de77-4586-9479-383661bf3397
begin
	struct _LR <: Optimizer end
	struct _LF <: LossFunction end
	function gradient(lm::LinearModel, lf::_LF, X::Matrix, Y::Vector)
		sum(X, dims=1)
	end
	function update!(lm::LinearModel, 
		 			 lf::_LF, 
		 			 opt::_LR, 
		 			 x::Matrix,
		 			 y::Vector)
		
		ϕ = get_features(lm, x)
		
		Δw = gradient(lm, lf, ϕ, y)[1, :]
		lm.w .-= Δw
	end
end;

# ╔═╡ 344092df-c60b-4f8d-8992-cae088664632
function update!(lm::LinearModel, 
				 lf::LossFunction, 
				 opt::ConstantLR, 
				 x::Matrix,
				 y::Vector)

	g = gradient(lm, lf, x, y)
	
	#### BEGIN SOLUTION
	lm.w.-=g.*opt.η
	#### END SOLUTION
end

# ╔═╡ fae6cbd5-b7fe-4043-a4b6-a4bc07caf7d9
function update!(lm::LinearModel, 
				 lf::LossFunction, 
				 opt::HeuristicLR, 
				 x::Matrix,
				 y::Vector)

	g = gradient(lm, lf, x, y)
	#### BEGIN SOLUTION
	d= length(g)
	sum=0.0
	for i in 1:d
		sum+=abs(g[i])
	end
	sum/=d
	opt.g_bar+=sum
	η=(1+opt.g_bar)^(-1)
	update=g.*η
	(lm.w.-=update)
	#### END SOLUTION
end

# ╔═╡ c2710a60-ebe1-4d01-b6d1-0d6fe45723f9
function update!(lm::LinearModel, 
				 lf::LossFunction,
				 opt::AdaGrad,
				 x::Matrix,
				 y::Vector)

	g = gradient(lm, lf, x, y)
	if size(g) !== size(opt.gbar) # need to make sure this is of the right shape.
		opt.gbar = zero(g)
	end
	
	# update opt.gbar and lm.w
	#### BEGIN SOLUTION
	n=length(lm.w)
	opt.gbar.+=(g.^2)
	lm.w.-= (opt.η./ sqrt.((opt.gbar .+ opt.ϵ) )) .* g
	#### END SOLUTION
	
end


# ╔═╡ 69cf84e2-0aba-4595-8cb0-c082dbccdbe2
function epoch!(mbgd::MiniBatchGD, model::LinearModel, lossfunc, opt, X, Y)
	perm=randperm(length(Y))
	X=X[perm,:]
	Y=Y[perm]
		
	batch_num=(length(Y))/Int(mbgd.n)
	for i in 1:batch_num
		low_range=Int((i-1)*mbgd.n +1)
		high_range=Int(i*mbgd.n)
		if high_range>length(Y)
			break
		end
		update!(model::LinearModel, lossfunc, opt, X[low_range:high_range,:],Y[low_range:high_range])
	end

end

# ╔═╡ eb5d3e74-f156-43a1-9966-4880f80a3d60
begin
	_check_ConstantLR = let
		lm = LinearModel(3, 1)
		opt = ConstantLR(0.1)
		lf = MSE()
		X = ones(4, 3)
		Y = [0.1, 0.2, 0.3, 0.4]
		update!(lm, lf, opt, X, Y)
		all(lm.w .== 0.025)
	end
	md"""
	### (d) $(_check_complete(_check_ConstantLR)) Constant Learning Rate 

	To update the weights for mini-batch gradient descent, we can use `ConstantLR` optimizer which updates the weights using a constant stepsize `η`
	
	```math
	w = w - η*g
	```
	
	where `g` is the gradient defined by the loss function.
	
	Implement the `ConstantLR` optimizer.
	"""
end

# ╔═╡ 9100674f-c3f9-4b4f-bca5-dd8bef5bc6e9
begin
	_check_HeuristicLR = let
		lm = LinearModel(3, 1)
		opt = HeuristicLR()
		lf = MSE()
		X = ones(4, 3)
		Y = [0.1, 0.2, 0.3, 0.4]
		update!(lm, lf, opt, X, Y)
		all(lm.w .≈ 0.11111111111111)
	end
	md"""
	### (e) $(_check_complete(_check_HeuristicLR)) Heuristic Learning Rate 

	To update the weights for mini-batch gradient descent, we can use `HeuristicLR` optimizer which updates the weights using a stepsize `η` that is a function of the gradient. We define the stepsize at time $t$ as:
	
	```math
	\eta_t = (1 + \bar{g}_{t})^{-1}
	```
	where $\bar{g}_{t}$ is an accumulating gradient over time that uses the gradient ```g``` defined by the loss function. We use the following to compute $\bar{g}_{t}$

	```math
	\bar{g}_{t} = \bar{g}_{t-1} + \frac{1}{d} \sum_{j=1}^d |g_{t, j}|
	```
	
	Then, we use the update
	
	```math
	w_{t} = w_{t-1} - \eta_t g_t
	```
	Implement the `HeuristicLR`.
	"""

end

# ╔═╡ 8dfd4734-5648-42f2-b93f-be304b4b1f27
begin
	 __check_AdaGrad_v, __check_AdaGrad_W = let
		lm = LinearModel(2, 1)
		opt = AdaGrad(0.1, lm)
		X = [0.1 0.5; 
			 0.5 0.0; 
			 1.0 0.2]
		Y = [1, 2, 3]
		update!(lm, MSE(), opt, X, Y)
		true_G = [1.8677777777777768, 0.13444444444444445]
		true_W = [0.09999973230327601, 0.099996281199188]
		true_G = reshape(true_G, length(true_G), 1)
		true_W = reshape(true_W, length(true_W), 1)
		check_elements(true_G, opt.gbar), check_elements(true_W, lm.w)
	end
	
	__check_AdaGrad = __check_AdaGrad_v && __check_AdaGrad_W
	
md"""
### (f) $(_check_complete(__check_AdaGrad)) AdaGrad 

	
"""
end

# ╔═╡ 3738f45d-38e5-415f-a4e6-f8922df84d09
md"""
Below you will need to implement three optimizers

- Constant learning rate $(_check_complete(_check_ConstantLR))
- Heuristic learning rate $(_check_complete(_check_HeuristicLR))
- AdaGrad $(_check_complete(__check_AdaGrad))
"""

# ╔═╡ 9d96ede3-533e-42f7-ada1-6e71980bc6c2
function epoch!(mbgd::MiniBatchGD, model::AbstractModel, lossfunc, opt, X, Y)
	epoch!(mbgd, get_linear_model(model), lossfunc, opt, get_features(lp.model, X), Y)
end

# ╔═╡ acf1b36c-0412-452c-ab4d-a388f84fd1fb
begin
	__check_MBGD = let

		lm = LinearModel(3, 1)
		opt = _LR()
		lf = _LF()
		X = ones(10, 3)
		Y = collect(0.0:0.1:0.9)
		mbgd = MiniBatchGD(5)
		epoch!(mbgd, lm, lf, opt, X, Y)
		all(lm.w .== -10.0)
	end
	str = "<h2 id=graddescent> (a) $(_check_complete(__check_MBGD)) Mini-batch Gradient Descent </h2>"
	HTML(str)
end

# ╔═╡ 6ff92fca-6d66-4f27-8e09-11a3887e66ba
function train!(mbgd::MiniBatchGD, model::AbstractModel, lossfunc, opt, X, Y, num_epochs)
	train!(mbgd, get_linear_model(model), lossfunc, opt, get_features(model, X), Y, num_epochs)
end

# ╔═╡ c59cf592-a893-4ffa-b247-51d94c7cdb1a
begin
		
	_check_Poly2 = let
		pm = Polynomial2Model(2, 1)
		rng = Random.MersenneTwister(1)
		X = rand(rng, 3, 2)
		Φ = get_features(pm, X)
		Φ_true = [
			1.0 0.23603334566204692 0.00790928339056074 0.05571174026441932 0.0018668546204633095 6.25567637522e-5; 
			1.0 0.34651701419196046 0.4886128300795012 0.12007404112451132 0.16931265897503248 0.2387424977182995; 
			1.0 0.3127069683360675 0.21096820215853596 0.09778564804593431 0.06597122691230639 0.04450758232200489]
		check_1 = check_elements(Φ_true, Φ) #all(Φ .≈ Φ_true)
		
		pm = Polynomial2Model(2, 1; ignore_first=true)
		X_bias = ones(size(X, 1), size(X, 2) + 1)
		X_bias[:, 2:end] .= X
		Φ = get_features(pm, X_bias)
		check_2 = check_elements(Φ_true, Φ)#all(Φ .≈ Φ_true)
		check_1 && check_2
	end
	
	HTML("<h2 id=poly> (g) $(_check_complete(_check_Poly2)) Polynomial Features </h2>")
end

# ╔═╡ 0608c93d-2f82-470c-8d9f-ca79af6b2612
predict(lm::Polynomial2Model, X) = predict(lm.model, get_features(lm, X))

# ╔═╡ ada800ba-25e2-4544-a297-c42d8b36a9ff
function loss(lm::AbstractModel, mse::MSE, X, Y)
	0.0
	#### BEGIN SOLUTION
	sum=0
	n=length(Y)
	for i in 1:n
		f_x=predict(lm,X[i,:])
		sum+=(f_x-Y[i])^2
	end
	(sum/=2*n)


	#### END SOLUTION
end

# ╔═╡ 2782903e-1d2e-47de-9109-acff4595de42
function train!(mbgd::MiniBatchGD, model::LinearModel, lossfunc, opt, X, Y, num_epochs)
	ℒ = zeros(num_epochs + 1)
	ℒ[1] = loss(model, lossfunc, X, Y)
	for i in 1:num_epochs
		epoch!(mbgd, model, lossfunc, opt, X, Y)
		ℒ[i+1] = loss(model, lossfunc, X, Y)
	end
	ℒ
end

# ╔═╡ a3387a7e-436c-4724-aa29-92e78ea3a89f
begin
	# __check_mseGrad 
	lm1 = LinearModel(3, 1)
	lm2 = LinearModel(3, 1)
	lm2.w .+= 1
	__check_mseloss = loss(lm1, MSE(), ones(4, 3), [1,2,3,4]) == 3.75 && loss(lm2, MSE(), ones(4, 3), [1,2,3,4]) == 0.75 && loss(lm2, MSE(), ones(4, 3), [7,8,9,0]) == 10.75
	__check_msegrad = all(gradient(LinearModel(3, 1), MSE(), ones(4, 3), [1,2,3,4]) .== -2.5)
	
	__check_MSE = __check_mseloss && __check_msegrad
	
md"""
For this notebook we will only be using MSE, but we still introduce the abstract type LossFunction for the future. Below you will need to implement the `loss` $(_check_complete(__check_mseloss)) function and the `gradient` $(_check_complete(__check_msegrad)) function for MSE.
"""
end

# ╔═╡ a9d3c6c3-1cb7-4417-ba6a-54998841c87d
let
	q2_a_check = _check_complete(_check_Poly2)
	q2_b_check = _check_complete(__check_MBGD)
	q2_c_check = _check_complete(__check_mseloss)
	q2_d_check = _check_complete(__check_msegrad)
	q2_e_check = _check_complete(_check_ConstantLR)
	q2_f_check = _check_complete(_check_HeuristicLR)
	q2_g_check = _check_complete(__check_AdaGrad)

md"""
# Preamble 

In this assignment, we will implement:
- Q2(a) [Mini-batch Gradient Descent](#graddescent) $(q2_b_check)
- Q2(b,c) [Loss functions](#lossfunc) MSE $(q2_c_check), and gradient of MSE $(q2_d_check)
- Q2(d-f) [Optimizers](#opt): Constant LR $(q2_e_check), Heuristic Stepsize $(q2_f_check), and AdaGrad $(q2_g_check)
- Q2(g) [Polynomial Features](#poly) $(q2_a_check)
"""
end

# ╔═╡ f380a361-2960-471b-b29a-3bd1fe06252b
md"""
### (b) $(_check_complete(__check_mseloss)) Mean Squared Error
"""

# ╔═╡ 7bea0c90-077f-4eca-b880-02d1289244f3
md"""
### (c) $(_check_complete(__check_msegrad)) Gradient of Mean Squared Error
"""

# ╔═╡ fa610de0-f8c7-4c48-88d8-f5398ea75ae2
md"""
# Evaluating Models

In the following section, we provide a few helper functions and structs to make evaluating methods straightforward. The abstract type `LearningProblem` with children `GDLearningProblem` and `OLSLearningProblem` are used to construct a learning problem. You will notice these structs contain all the information needed to `train!` a model. We also provide the `run` and `run!` functions. These will update the transform according to the provided data and train the model. `run` does this with a copy of the learning problem, while `run!` does this inplace. 

"""

# ╔═╡ d695b118-6d0d-401d-990f-85ba467cc53e
abstract type LearningProblem end

# ╔═╡ 6edc243e-59ac-4c6f-b507-80d3ec13bc21
"""
	GDLearningProblem

This is a struct for keeping a the necessary gradient descent learning setting components together.
"""
struct GDLearningProblem{M<:AbstractModel, O<:Optimizer, LF<:LossFunction} <: LearningProblem
	gd::MiniBatchGD
	model::M
	opt::O
	loss::LF
end

# ╔═╡ 3bdde6cf-3b68-46d3-bf76-d68c20b661e9
Base.copy(lp::GDLearningProblem) = 
	GDLearningProblem(lp.gd, copy(lp.model), copy(lp.opt), lp.loss)

# ╔═╡ 7905f581-1593-4e06-8aaf-faec05c3b306
function run!(lp::GDLearningProblem, X, Y, num_epochs)
	update_transform!(lp.model, X, Y)
	train!(lp.gd, lp.model, lp.loss, lp.opt, X, Y, num_epochs)
end

# ╔═╡ 69b96fc3-dc9c-44de-bc7f-12bb8aba85d1
function run(lp::LearningProblem, args...)
	cp_lp = copy(lp)
	ℒ = run!(cp_lp, args...)
	return cp_lp, ℒ
end

# ╔═╡ eef918a9-b8af-4d41-85b1-bebf1c7889cc
HTML("<h4 id=cv> Run Experiment </h2>")

# ╔═╡ fd75ff49-b5de-48dc-ae89-06bf855d81b2
md"""

Below are the helper functions for running an experiment.

"""

# ╔═╡ d339a276-296a-4378-82ae-fe498e9b5181
"""
	run_experiment(lp, X, Y, num_epochs, runs; train_size)

Using `train!` do `runs` experiments with the same train and test split (which is made by `random_dataset_split`). This will create a copy of the learning problem and use this new copy to train. It will return the estimate of the error.
"""
function run_experiment(lp::LearningProblem, 
						train_data, 
						test_data,	 
						num_epochs,
						runs)

	err = zeros(runs)
	
	for i in 1:runs		
		# train
		cp_lp, train_loss = run(lp, train_data[1], train_data[2], num_epochs)
		
		# test
		Ŷ = predict(cp_lp.model, test_data[1])
		err[i] = sqrt(mean(abs2, test_data[2] - Ŷ))
	end

	err
end

# ╔═╡ 58e626f1-32fb-465a-839e-1f413411c6f3
md"
# Experiments

In this section, we will run three experiments on the different algorithms we implemented above. We provide the data in the `Data` section, and then follow with the three experiments and their descriptions. You will need to analyze and understand the three experiments for the written portion of this assignment.
"

# ╔═╡ 5ec88a5a-71e2-40c1-9913-98ced174341a
md"""
## Data

This section creates the datasets we will use in our comparisons. Feel free to play with them in `let` blocks.
"""

# ╔═╡ 12d0a092-e5d5-4aa1-ac82-5d262f54aa6d
"""
	splitdataframe(split_to_X_Y::Function, df::DataFrame, test_perc; shuffle = false)
	splitdataframe(df::DataFrame, test_perc; shuffle = false)

Splits a dataframe into test and train sets. Optionally takes a function as the first parameter to split the dataframe into X and Y components for training. This defaults to the `identity` function.
"""
function splitdataframe(split_to_X_Y::Function, df::DataFrame, test_perc; 
		                shuffle = false)
	#= shuffle dataframe. 
	This is innefficient as it makes an entire new dataframe, 
	but fine for the small dataset we have in this notebook. 
	Consider shuffling inplace before calling this function.
	=#
	
	df_shuffle = if shuffle == true
		df[randperm(nrow(df)), :]
	else
		df
	end
	
	# Get train size with percentage of test data.
	train_size = Int(round(size(df,1) * (1 - test_perc)))
	
	dftrain = df_shuffle[1:train_size, :]
	dftest = df_shuffle[(train_size+1):end, :]
	
	split_to_X_Y(dftrain), split_to_X_Y(dftest)
end


# ╔═╡ d2c516c0-f5e5-4476-b7d6-89862f6f2472
function unit_normalize_columns!(df::DataFrame)
	for name in names(df)
		mn, mx = minimum(df[!, name]), maximum(df[!, name])
		df[!, name] .= (df[!, name] .- mn) ./ (mx - mn)
	end
	df
end

# ╔═╡ 72641129-5274-47b6-9967-fa37c8036552
md"""
### **Admissions Dataset**
"""

# ╔═╡ 90f34d85-3fdc-4e2a-ada4-085154103c6b
admissions_data = let
	data = CSV.read("data/admission.csv", DataFrame, delim=',', ignorerepeated=true)[:, 2:end]
	data[!, 1:end-1] = unit_normalize_columns!(data[:, 1:end-1])
	data
end;

# ╔═╡ 14b329fb-8053-4148-8d24-4458e592e7e3
# md"""
# ## Plotting our results

# The `plot_results` function produces two plots: a box plot over the errors and a bar graph displaying average errors with standard error bars. We show both so that you can visualize the results in two ways and because the box plot expands the y-axis, making it harder to see differences between some of the methods. This function will be used for all the experiments, and you should use this to finish your written experiments.

# """
md"""
# Plotting Utilities

Below we define two plotting helper functions for using PlotlyJS. You can ignore these if you want. We use them below to compare the algorithms.
"""

# ╔═╡ 3fce1f5f-de97-45b3-b453-1615153118eb
color_scheme = [
    colorant"#44AA99",
    colorant"#332288",
    colorant"#DDCC77",
    colorant"#999933",
    colorant"#CC6677",
    colorant"#AA4499",
    colorant"#117733",
    colorant"#882255",
    colorant"#1E90FF",
]

# ╔═╡ f17ad861-3da5-4dc1-90ac-a1085b6c2653
"""
	plot_results

This function uses PlotlyJS to plot a box plot of the perfomance for each algorithm.
"""
function plot_results(names::Vector{String}, 
				 data::Vector{<:AbstractVector};
				 col=color_scheme,
				 kwargs...)
	
	traces = GenericTrace{Dict{Symbol, Any}}[]
	for (idx, (name, datum)) in enumerate(zip(names, data))
		tr_bx = box(
			name=name, 
			y=datum, 
			jitter=0.3, 
			marker_color=col[idx])
		push!(traces, tr_bx)
	end
	layout = Layout(; showlegend=false, kwargs...)
	plt = Plot(traces, layout)
end

# ╔═╡ b689d666-37da-40f7-adb8-44aa2b9f5139
md"""
## (h) Comparing Linear Regression and Polynomial Regression 

We will compare the linear regression and polynomial regression with $p=2$ using the a simulated data set and the admissions dataset.

To run these experiments use $(@bind __run_nonlinear PlutoUI.CheckBox())
"""

# ╔═╡ 55ce32ff-dec3-4bd4-b6a2-95483e7637e9
md"""
This first experiment uses a simulated training set. For a given input $\mathbf{x} \in [0.0, 1.0]^5$, the nonlinear function that defines $\mathbb{E}[Y | \mathbf{x}]$ is

```julia
f(x) = sin(π*x[1]*x[2]^2) + cos(π*x[3]^3) + x[5]*sin(π*x[4]^4) + 0.001*randn()
```
To get the target, we use 
```julia
y = f(x) + 0.001*randn()
```
namely we add a small amount of Gaussian noise. We compare a linear regression, polynomial regression and two baselines.
"""

# ╔═╡ d381d944-5069-4f16-8194-bd49eb2fe1cd
let
	if __run_nonlinear
		algs = ["Random", "Mean", "Linear", "Poly"]
		non_linear_problems_sin = [
			GDLearningProblem(
				MiniBatchGD(30),
				RandomModel(5, 1),
				ConstantLR(0.0),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				MeanModel(),
				ConstantLR(0.0),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				LinearModel(5, 1),
				ConstantLR(1.0),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				Polynomial2Model(5, 1),
				ConstantLR(0.5),
				MSE())
			];
		nonlinear_errs_sin = let
			Random.seed!(2)
			X = rand(500, 5)
			f(x) = sin(π*x[1]*x[2]^2) + cos(π*x[3]^3) + x[5]*sin(π*x[4]^4) + 0.001*randn()
			Y = [f(x) for x in eachrow(X)]
			Y .= (Y.-minimum(Y))/(maximum(Y) - minimum(Y))
			plot(Y)
			errs = Vector{Float64}[]
			
			train_size=400
			
			rp = randperm(length(Y))
			train_idx = rp[1:train_size]
			test_idx = rp[train_size+1:end]
			train_data = (X[train_idx, :], Y[train_idx]) 
			test_data = (X[test_idx, :], Y[test_idx])
			
			for (idx, prblms) in enumerate(non_linear_problems_sin)
				cv_err = run_experiment(prblms, train_data, test_data, 10, 50)
				push!(errs, cv_err)
			end
			errs
		end

		stderr(x) = sqrt(var(x)/length(x))
		df = DataFrame(
			Model=["Random", "Mean", "Linear", "Poly"],
			AvgError = mean.(nonlinear_errs_sin),
			StandardError = stderr.(nonlinear_errs_sin)
		)
		@info df
		@show "Synthetic Data"
		@show df
		
		# plot_results(algs, nonlinear_errs_sin, "Synthetic Data")
		p = plot_results(algs, nonlinear_errs_sin)
		PlotlyJS.relayout(p, height=400, showlegend=false, title="Synthetic Data")
	end
end

# ╔═╡ 80406819-83d2-4625-8ed3-959c127e3e2c
md"""
The following experiment uses the addmistions dataset, which you should report. **You can get the average error and standard error to report from the plot or from below the plot and experiment code**.
"""

# ╔═╡ 5a4ac4ed-6ed5-4d28-981e-8bf7b6b8889d
let
	if __run_nonlinear
		algs = ["Random", "Mean", "Linear", "Poly"]
		non_linear_problems = [
			GDLearningProblem(
				MiniBatchGD(30),
				RandomModel(7, 1),
				ConstantLR(0.0),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				MeanModel(),
				ConstantLR(0.0),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				LinearModel(7, 1),
				ConstantLR(0.5),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				Polynomial2Model(7, 1),
				ConstantLR(0.2),
				MSE()),
		]
		nonlinear_errs = let

			Random.seed!(2)
			data = (X=Matrix(admissions_data[:, 1:end-1]), Y=admissions_data[:, end])
			errs = Vector{Float64}[]
			
			X, Y = data.X, data.Y
			train_size=350
			
			rp = randperm(length(Y))
			train_idx = rp[1:train_size]
			test_idx = rp[train_size+1:end]
			train_data = (X[train_idx, :], Y[train_idx]) 
			test_data = (X[test_idx, :], Y[test_idx])
			
			for (idx, prblms) in enumerate(non_linear_problems)
				err = run_experiment(
					prblms, train_data, test_data, 10, 50)
				push!(errs, err)
			end
			errs
		end
		
		num_runs = size(nonlinear_errs[4])
		stderr(x) = sqrt(var(x)/length(x))
		mean_error_linear = mean(nonlinear_errs[3])
		mean_error_poly = mean(nonlinear_errs[4])
		
		std_error_linear = stderr(nonlinear_errs[3])
		std_error_poly = stderr(nonlinear_errs[4])
		
		# println("Average error on test set for the Linear model is $mean_error_linear with standard error $std_error_linear")
		# println("Average error on test set for the Polynomial model is $mean_error_poly with standard error $std_error_poly")

		df = DataFrame(
			Model=[:Random, :Mean, :Linear, :Poly],
			AvgError = mean.(nonlinear_errs),
			StandardError = stderr.(nonlinear_errs)
		)
		@info df

		@show "Admissions Dataset"
		@show df

		p = plot_results(algs, nonlinear_errs)
		PlotlyJS.relayout(p, height=400, showlegend=false, Title="Admissions Dataset")
	end
end

# ╔═╡ 0903dd95-5525-44e5-891d-acbe2fb2190f
md"""
## (i) Stepsize Adaptation

We will compare the different stepsize algorithms on a subset of the [Admissions dataset](). From this dataset we will be predicting the likelihood of admission.

To run this experiment click $(@bind __run_lra PlutoUI.CheckBox())

**You can get the average error and standard error to report from the plot or from the terminal where your ran this notebook or from below the plot and experiment code**.
"""

# ╔═╡ c01ff616-e570-4013-a0b2-d97fcda6f279
let
	if __run_lra
		algs_lr = ["Constant", "Heuristic", "AdaGrad"]
		lr_adapt_problems = [
			GDLearningProblem(
				MiniBatchGD(30),
				Polynomial2Model(7, 1),
				ConstantLR(0.2),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				Polynomial2Model(7, 1),
				HeuristicLR(),
				MSE()),
			GDLearningProblem(
				MiniBatchGD(30),
				Polynomial2Model(7, 1),
				AdaGrad(0.5),
				MSE()),
		];
		lr_errs = let
			
			Random.seed!(2)
			test_idx = 1
			data = (X=Matrix(admissions_data[:, 1:end-1]), Y=admissions_data[:, end])
			@show size(data.X)
			errs = Vector{Float64}[]
			
			X, Y = data.X, data.Y
			train_size=350
			
			rp = randperm(length(Y))
			train_idx = rp[1:train_size]
			test_idx = rp[train_size+1:end]
			train_data = (X[train_idx, :], Y[train_idx]) 
			test_data = (X[test_idx, :], Y[test_idx])
			
			for (idx, prblms) in enumerate(lr_adapt_problems)

				err = run_experiment(prblms, train_data, test_data, 5, 50)
				push!(errs, err)
			end
			errs
		end
		num_runs = size(lr_errs[3])
		stderr(x) = sqrt(var(x)/length(x))
		
		mean_error_constantLR = mean(lr_errs[1])
		mean_error_HeuristicLR = mean(lr_errs[2])
		mean_error_AdaGrad = mean(lr_errs[3])
		
		std_error_constantLR = stderr(lr_errs[1])
		std_error_HeuristicLR = stderr(lr_errs[2])
		std_error_AdaGrad = stderr(lr_errs[3])
		
		# println("Average error on test set for Linear model with ConstantLR is $mean_error_constantLR with standard error $std_error_constantLR")
		
		# println("Average error on test set for Linear model with HeuristicLR is $mean_error_HeuristicLR with standard error $std_error_HeuristicLR")
		
		# println("Average error on test set for Linear model with AdaGrad is $mean_error_AdaGrad with standard error $std_error_AdaGrad")

		df = DataFrame(StepsizeAlg=["Constant", "Heuristic", "AdaGrad"],
				  AvgError = [mean_error_constantLR, mean_error_HeuristicLR, mean_error_AdaGrad],
				  StandardError = [std_error_constantLR, std_error_HeuristicLR, std_error_AdaGrad])
		@info df 

		@show "Stesize Algorithm Comparions"
		@show df
		
		p = plot_results(algs_lr, lr_errs)
		PlotlyJS.relayout(p, height=400, showlegend=false, title="Stesize Algorithm Comparions")
	end

end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
MultivariateStats = "6f286f6a-111f-5878-ab1e-185364afe411"
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.2"
Colors = "~0.12.8"
DataFrames = "~1.3.2"
Distributions = "~0.25.49"
MultivariateStats = "~0.9.0"
PlotlyJS = "~0.18.8"
PlutoUI = "~0.7.35"
StatsBase = "~0.33.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "91ca22c4b8437da89b030f08d71db55a379ce958"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.3"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BinDeps]]
deps = ["Libdl", "Pkg", "SHA", "URIParser", "Unicode"]
git-tree-sha1 = "1289b57e8cf019aede076edab0587eb9644175bd"
uuid = "9e28174c-4ba2-5203-b857-d8d62c4213ee"
version = "1.0.2"

[[deps.Blink]]
deps = ["Base64", "BinDeps", "Distributed", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Reexport", "Sockets", "WebIO", "WebSockets"]
git-tree-sha1 = "08d0b679fd7caa49e2bca9214b131289e19808c0"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.5"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "9519274b50500b8029973d241d32cfbf0b127d97"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.2"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c9a6160317d1abe9c44b3beb367fd448117679ca"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.13.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "9d3c0c762d4666db9187f363a76b47f7346e673b"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.49"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "84f04fe68a3176a583b864e492578b9466d87f1e"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.6"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "04d13bfa8ef11720c24e4d840c0033d145537df7"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.17"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "4c7d3757f3ecbcb9055870351078552b7d1dbd2d"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "61feba885fac3a407465726d0c330b3055df897f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "bd6c034156b1e7295450a219c4340e32e50b08b1"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.3"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2ef87eeaa28713cb010f9fb0be288b6c1a4ecd53"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.1.0+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "6d019f5a0465522bbfdd68ecfad7f86b535d6935"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.9.0"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "bfbd6fb946d967794498790aa7a0e6cdf1120f41"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.13"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "Pkg", "Sockets", "WebSockets"]
git-tree-sha1 = "82dfb2cead9895e10ee1b0ca37a01088456c4364"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "0.7.6"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "7e2166042d1698b6072352c74cfd1fca2a968253"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.6"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "53d6325e14d3bdb85fd387a085075f36082f35a3"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.8"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "de893592a221142f3db370f48290e3a2ef39998f"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.4"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "85e5b185ed647b8ee89aa25a7788a2b43aa8a74f"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "25405d7016a47cf2bd6cd91e66f4de437fd54a07"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.16"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.URIParser]]
deps = ["Unicode"]
git-tree-sha1 = "53a9f49546b8d2dd2e688d216421d050c9a31d0d"
uuid = "30578b45-9adc-5946-b283-645ec420af67"
version = "0.4.1"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "5fe32e4086d49f7ab9b087296742859f3ae6d62a"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.16"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "f91a602e25fe6b89afc93cf02a4ae18ee9384ce3"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.5.9"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "505c31f585405fc375d99d02588f6ceaba791241"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─75441ce6-2137-4fcf-bba2-6ed67b9acb59
# ╠═dc004086-db6e-4813-841e-d427520402f7
# ╠═6123f99e-bbfd-4e5c-aba8-fb0cc67b923d
# ╟─693a3933-c1c2-4249-8c03-f5151267222f
# ╠═bc0c5abe-1c2a-4e5c-bb0c-8d76b5e81133
# ╠═def97306-1703-42bc-bc09-da623c545e87
# ╟─14c30b50-157f-40bf-b0a6-0232aa2705c6
# ╠═4a196e82-fe94-49fe-ab87-d57e2d7fbd34
# ╟─a9d3c6c3-1cb7-4417-ba6a-54998841c87d
# ╟─fc673678-945c-4ec3-8c2a-47eacbe00492
# ╟─a7aecd21-13f2-4cf2-8239-3a3d708602c9
# ╟─e3c3e903-e2c2-4de0-a3b2-56a27709e8c3
# ╟─3237c4fc-56d1-4135-a8d2-cc6e88f2f5c0
# ╠═5080cc19-d13f-4236-b49e-e338108dda80
# ╟─a35944ae-7bbb-4f3c-bbe0-d2bbb57cd70b
# ╠═e7712bd3-ea7e-4f4a-9efc-041b4b2be987
# ╟─4f4029a2-c590-4bd3-a0db-d2380d4b4620
# ╟─dcfecc35-f25c-4856-8429-5c31d94d0a42
# ╠═d45dedf8-e46a-4ffb-ab45-f9d211d3a8ca
# ╠═7cd46d84-a74c-44dc-8339-68010924bc39
# ╟─8745fec1-47c8-428b-9ea4-1e6828618830
# ╠═2d43a3ba-2a2c-4114-882f-5834d42e302a
# ╠═acf1b36c-0412-452c-ab4d-a388f84fd1fb
# ╟─fbbcda71-43a2-4484-87b5-05a81d2101e7
# ╠═159cecd9-de77-4586-9479-383661bf3397
# ╠═d9935cc8-ec24-47e9-b39a-92c21377a161
# ╟─5714c84f-1653-4c4a-a2e4-003d8560484a
# ╠═69cf84e2-0aba-4595-8cb0-c082dbccdbe2
# ╠═9d96ede3-533e-42f7-ada1-6e71980bc6c2
# ╠═6ff92fca-6d66-4f27-8e09-11a3887e66ba
# ╠═2782903e-1d2e-47de-9109-acff4595de42
# ╟─a17e5acd-d78d-4fab-9ab2-f01bd888339d
# ╠═a3387a7e-436c-4724-aa29-92e78ea3a89f
# ╠═7e777dba-b389-4549-a93a-9b0394646c57
# ╟─f380a361-2960-471b-b29a-3bd1fe06252b
# ╟─6d2d24da-9f3f-43df-9243-fc17f85e0b01
# ╠═4f43373d-42ee-4269-9862-f53695351ea3
# ╠═ada800ba-25e2-4544-a297-c42d8b36a9ff
# ╟─7bea0c90-077f-4eca-b880-02d1289244f3
# ╟─4ea14063-99ca-4caf-a862-fbf9590c68a2
# ╠═299116ea-66f3-4e52-ab0f-594249b9dd23
# ╠═af8acfdf-32bd-43c1-82d0-99008ee4cb3e
# ╟─3738f45d-38e5-415f-a4e6-f8922df84d09
# ╠═36c1f5c8-ac43-41ea-9100-8f85c1ee3708
# ╠═eb5d3e74-f156-43a1-9966-4880f80a3d60
# ╠═0f6929b6-d869-4c3c-90f6-c923b265b164
# ╠═8b8fd9b8-a41b-4fef-96b7-a146986c6f82
# ╠═344092df-c60b-4f8d-8992-cae088664632
# ╠═9100674f-c3f9-4b4f-bca5-dd8bef5bc6e9
# ╠═695d7dea-c398-43dd-a342-c204c050477e
# ╠═7a4f745a-cb65-49d0-80fa-0e67a75df2c1
# ╠═fae6cbd5-b7fe-4043-a4b6-a4bc07caf7d9
# ╟─8dfd4734-5648-42f2-b93f-be304b4b1f27
# ╟─77cda37c-c560-42d8-85b1-7f026d09edfe
# ╠═1fe7084a-9cf9-48a4-9e60-b712365eded9
# ╠═c2710a60-ebe1-4d01-b6d1-0d6fe45723f9
# ╠═c59cf592-a893-4ffa-b247-51d94c7cdb1a
# ╟─ded749bf-b9fa-4e2b-b15f-0693d820a9c3
# ╠═2e69a549-aab4-4c88-aad8-dffb822d644f
# ╠═0608c93d-2f82-470c-8d9f-ca79af6b2612
# ╠═0ba5f9c8-5677-40e9-811b-25546e0df207
# ╟─fa610de0-f8c7-4c48-88d8-f5398ea75ae2
# ╠═d695b118-6d0d-401d-990f-85ba467cc53e
# ╠═6edc243e-59ac-4c6f-b507-80d3ec13bc21
# ╠═3bdde6cf-3b68-46d3-bf76-d68c20b661e9
# ╠═7905f581-1593-4e06-8aaf-faec05c3b306
# ╠═69b96fc3-dc9c-44de-bc7f-12bb8aba85d1
# ╟─eef918a9-b8af-4d41-85b1-bebf1c7889cc
# ╟─fd75ff49-b5de-48dc-ae89-06bf855d81b2
# ╟─d339a276-296a-4378-82ae-fe498e9b5181
# ╟─58e626f1-32fb-465a-839e-1f413411c6f3
# ╟─5ec88a5a-71e2-40c1-9913-98ced174341a
# ╟─12d0a092-e5d5-4aa1-ac82-5d262f54aa6d
# ╠═d2c516c0-f5e5-4476-b7d6-89862f6f2472
# ╟─72641129-5274-47b6-9967-fa37c8036552
# ╠═90f34d85-3fdc-4e2a-ada4-085154103c6b
# ╟─14b329fb-8053-4148-8d24-4458e592e7e3
# ╟─3fce1f5f-de97-45b3-b453-1615153118eb
# ╟─f17ad861-3da5-4dc1-90ac-a1085b6c2653
# ╟─b689d666-37da-40f7-adb8-44aa2b9f5139
# ╟─55ce32ff-dec3-4bd4-b6a2-95483e7637e9
# ╟─d381d944-5069-4f16-8194-bd49eb2fe1cd
# ╟─80406819-83d2-4625-8ed3-959c127e3e2c
# ╟─5a4ac4ed-6ed5-4d28-981e-8bf7b6b8889d
# ╟─0903dd95-5525-44e5-891d-acbe2fb2190f
# ╟─c01ff616-e570-4013-a0b2-d97fcda6f279
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
