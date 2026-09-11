output "control_plane_public_ip" {
  value = module.compute.control_plane_public_ip
}

output "control_plane_private_ip" {
  value = module.compute.control_plane_private_ip
}

output "worker_1_public_ip" {
  value = module.compute.worker_1_public_ip
}

output "worker_1_private_ip" {
  value = module.compute.worker_1_private_ip
}

output "worker_2_public_ip" {
  value = module.compute.worker_2_public_ip
}

output "worker_2_private_ip" {
  value = module.compute.worker_2_private_ip
}
