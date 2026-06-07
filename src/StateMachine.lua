StateMachine = Class()

function StateMachine:init(states)
	self.states = states
	self.current = BaseState()
end

function StateMachine:change(state, params)
	self.current:exit()
	self.current = self.states[state]()
	self.current:enter(params)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
