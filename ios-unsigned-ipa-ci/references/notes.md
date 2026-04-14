# iOS unsigned IPA CI skill quick notes

## Default decision order
1. Understand user goal
2. Collapse into minimal runnable iOS app
3. Generate SwiftUI + XcodeGen project when suitable
4. Optimize for compileability and verifiability first
5. Push to GitHub
6. Run Actions
7. Deliver device-only unsigned IPA artifact

## Hard defaults
- Default output: device-only unsigned IPA
- Build first, release second
- New Apple frameworks must have fallback for CI
- Prefer SSH push; fallback to token-based HTTPS
- Verify with `gh run list -w "Build unsigned IPA"`

## Optimization priority
- Compileability
- Verifiability
- Structure
- UX polish
