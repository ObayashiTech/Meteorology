ExUnit.start()

Mox.defmock(Meteorology.Integrations.OpenMeteo.HTTP.MockClient,
  for: Meteorology.Integrations.OpenMeteo.HTTP.Behaviour
)

Mox.set_mox_private()
