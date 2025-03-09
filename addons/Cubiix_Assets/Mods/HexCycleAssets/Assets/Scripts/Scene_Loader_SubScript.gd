extends Node3D

signal FinishedLoad

func setup() -> void:
	call_deferred("emit_signal","FinishedLoad")
