using Godot;
using System;
using System.Reflection;

namespace WheelScript;

[GlobalClass]
public partial class WheelScript : RayCast3D
{
    [Export] public RigidBody3D car;

    [ExportGroup("Suspension")]
    [Export] public float RestLenght;
    [Export] public float SpringStiffnes;
    [Export] public float DamperStiffnes;
    [Export] public float WheelRadius;

    public float ElasticForce;
    public float DamperForce;
    float InitialSuspSize;
    float SuspSize;

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        TargetPosition = new Vector3(0, -RestLenght + WheelRadius, 0);
        float deltaf = (float) delta;

        if (IsColliding()){
            float distance = GlobalPosition.DistanceTo(GetCollisionPoint());
            InitialSuspSize = SuspSize;
            SuspSize = distance - WheelRadius;

            ElasticForce = SpringStiffnes * (RestLenght - SuspSize);
            DamperForce = DamperStiffnes * ((InitialSuspSize - SuspSize) / deltaf);

            car.ApplyForce(Basis.Y * (ElasticForce + DamperForce), GlobalPosition - car.GlobalPosition);

            
        }
    }
}
