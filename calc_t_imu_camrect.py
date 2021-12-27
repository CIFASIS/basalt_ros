import numpy as np
import evo.core.transformations as tf

# Calibration (Kalibr)
T_imu_cam0 = np.array([[0.009471441780975032, -0.9939081748565041, 0.10980360533243941, -0.030950056130583600],
	 [0.9984567420628084, 0.0033909183804303744, -0.055431362078334365, -0.077136433704428381],
	 [0.05472134884952806, 0.11015916496574298, 0.9924064350628417, 0.026512487799308242],
	 [0.0, 0.0, 0.0, 1.0]])

T_imu_cam1 = np.array([[0.010486169744957197, -0.9940873423040585, 0.10807588128224391, -0.029702271983652186],
	 [0.9972728488827708, 0.002500626397312078, -0.07376050263429253, 0.041641180069859347],
	 [0.07305412462908822, 0.10855460717295605, 0.9914025378907414, 0.033393889310081332],
	 [0.0, 0.0, 0.0, 1.0]])

# Rectification matrix (from camera_info)
R_cam0rect_cam0 = np.array([0.999873448071739, 0.0007366880139693224, 0.015891668631757446, -0.0007117643758229365, 0.9999985080430129, -0.0015739451138449111, -0.01589280442857141, 0.0015624348044513143, 0.9998724806518465]).reshape(3,3)
R_cam0_cam0rect = R_cam0rect_cam0.transpose()

R_cam1rect_cam1 = np.array([0.9999973307670281, -0.00043956732938318916, 0.0022683120115662946, 0.0004360095298107782, 0.9999986744820188, 0.0015687351258854836, -0.0022689985695877315, -0.0015677419329123293, 0.9999961969081298]).reshape(3,3)
R_cam1_cam1rect = R_cam1rect_cam1.transpose()


def get_T_imu_camrect(T_imu_cam, R_cam_camrect):
    T_cam_camrect = np.eye(4)
    T_cam_camrect[:3,:3] = R_cam_camrect
    return T_imu_cam.dot(T_cam_camrect)


def quaternion_from_transformation(T):
    return tf.quaternion_from_matrix(T)    


def traslation_from_transformation(T):
    return T[:3,3]

def print_p_q_from_transformation(T):
    print("**** From Transformation:")
    print(T)
    
    print("\nTraslation vector:")
    p = traslation_from_transformation(T)
    print(p)
    print("\nQuaternion: (format: qw, qx, qy, qz)")
    q = quaternion_from_transformation(T)
    print(q)
    print("****")

T_imu_cam0rect = get_T_imu_camrect(T_imu_cam0, R_cam0_cam0rect)
T_imu_cam1rect = get_T_imu_camrect(T_imu_cam1, R_cam1_cam1rect)

print_p_q_from_transformation(T_imu_cam0rect)
print_p_q_from_transformation(T_imu_cam1rect)




