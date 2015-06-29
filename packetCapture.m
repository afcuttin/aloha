function [capturedSource] =  packetCapture(sourceStatus,sourcePower,sourceRho,captureThreshold)
% function [capturedSource] =  capture(sourceStatus,sourcePower,sourceRho,captureThreshold)
% Evaluates the capture effect for colliding packets in an Aloha-like environment.
%
% Returns 0 if no capture occurs.
% If capture occurs, returns the index of sourceStatus corresponding to the source whose packet has been captured

% TODO: add input parameters check [Issue: https://github.com/afcuttin/aloha/issues/3]

% these parameters can be exposed as function parameters
pathLossAlpha = 4; % 2 correspond to free space path loss, 4 to cellular environment
pathLossModel = 1; % 1 for Bounded Path Loss Model, 0 for Unbouded Path Loss Model

if numel(find(sourceStatus == 1)) == 1
	capturedSource = find(sourceStatus == 1)
	fprintf('Warning: there are no collisions!\nNevertheless, I provide you with the right answer without computing the capture ratio.\n')
elseif numel(find(sourceStatus == 1)) > 1
	collided = find(sourceStatus == 1)
	receivedPower = sourcePower(collided)./(pathLossModel+sourceRho(collided).^pathLossAlpha)
	captured = collided(find(receivedPower == max(receivedPower)))
	interfering = setdiff(collided,captured)
	captureRatio = sum(receivedPower.*ismember(collided,captured)) / sum(receivedPower.*not(ismember(collided,captured)))
	captureRatiodB = 10 * log10(captureRatio)
	if captureRatiodB >= captureThreshold
		capturedSource = captured;
	elseif captureRatiodB < captureThreshold
		capturedSource = 0;
	end
end

