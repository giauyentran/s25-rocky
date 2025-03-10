function Calibrating_Gyro()
    % data collected from swinging Rocky
    gyro_data = [1.84
    1.87
    1.89
    1.90
    -1.66
    -1.66
    -1.67
    -1.70
    -1.72
    -1.76
    -1.80
    -1.83
    -1.88
    -1.92
    -1.95
    -1.98
    -2.00
    -2.01
    1.66
    1.66
    1.67
    1.69
    1.71
    1.74
    1.77
    1.79
    1.82
    -1.67
    -1.69
    -1.72
    -1.75
    -1.78
    -1.82
    -1.86
    -1.89
    -1.92
    -1.94
    -1.96
    -1.97
    1.66
    1.66
    1.67
    1.68
    1.70
    1.73
    1.75
    1.77
    1.80
    1.81
    1.82
    -1.66
    -1.66
    -1.66
    -1.67
    -1.69
    -1.72
        -1.74
    -1.78
    -1.81
    -1.84
    -1.87
    -1.90
    -1.91
    -1.93
    -1.94
    1.66
    1.66
    1.67
    1.68
    1.70
    1.72
    1.74
    1.76
    1.77
    1.79
    1.79
    -1.66
    -1.66
    -1.66
    -1.68
    -1.70
    -1.72
    -1.75
    -1.78
    -1.80
        -1.83
    -1.86
    -1.87
    -1.89
    -1.90
    -1.91
    1.66
    1.66
    1.66
    1.68
    1.69
    1.71
    1.72
    1.74
    1.75
    1.76
    -1.66
    -1.66
    -1.66
    -1.66
    -1.68
    -1.69
    -1.72
    -1.74
    -1.76
    
        -1.81
    -1.83
    -1.85
    -1.86
    -1.87
    1.66
    1.66
    1.66
    1.66
    1.67
    1.68
    1.70
    1.71
    1.72
    1.73
    1.74
    -1.66
    -1.66
    -1.66
    -1.67
    -1.68
    -1.70
    -1.72
    
        -1.78
    -1.80
    -1.82
    -1.83
    -1.84
    -1.85
    1.66
    1.66
    1.66
    1.66
    1.67
    1.68
    1.69
    1.70
    1.71
    1.72
    -1.66
    -1.66
    -1.66
    -1.66
    -1.67
    -1.68
    -1.70
    -1.72
    -1.73
    -1.75
    -1.77
    -1.79
    -1.80
        -1.81
    -1.82
    -1.83
    1.66
    1.66
    1.66
    1.66
    1.66
    1.67
    1.68
    1.69
    1.69
    -1.66
    -1.66
    -1.66
    -1.66
    -1.66
    -1.68
    -1.69
    -1.70
    -1.72
    -1.74
    -1.75
    -1.76
    -1.78
        -1.79
    -1.80
    -1.81
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.67
    -1.66
    -1.66
    -1.66
    -1.66
    -1.66
    -1.66
    -1.67
    -1.68
    -1.69
    -1.70
    -1.72
    -1.73
    -1.74
    -1.75-1.77
    -1.78
    -1.78
    -1.79
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    -1.66
    -1.66
    
        -1.67
    -1.68
    -1.69
    -1.70
    -1.71
    -1.73
    -1.74
    -1.75
    -1.76
    -1.76
    -1.77
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    1.66
    -1.66
    1.66
    -1.66
    1.66
    -1.66
    -1.66
    -1.67
    -1.68
    -1.69
    -1.70
    -1.71];

    % time data was collected
    time = linspace(0, length(gyro_data)*50e-3, length(gyro_data));

    % plotting data
    clf
    plot(time, gyro_data)
    title('Calibrating Gyro')
    xlabel('time [s]')
    ylabel('angle [rad]')
    
    % peaks from data from visually looking at plot
    peaks = [.15, 1.3, 2.46, 3.76, 5.02, 6.27, 7.43, 8.53, 9.74, 10.99, 12.1];
    
    % finding distances between peaks and taking their average to find the
    % period
    peak_diffs = zeros(1, length(peaks)-1);
    for i = 1:length(peaks)-1
        peak_diffs = peaks(i+1) - peaks(i);
    end
    
    % natural frequency is 1/period
    f = 1/mean(peak_diffs)

    angular_frequency = 2*pi*f

    g = 9.81; % acceleration due to gravity (m/s^2)
    l_eff = g / (angular_frequency^2);
    fprintf('Effective length (l_eff) = %.4f m\n', l_eff);

    zeta = 0.7;

    p1 = -zeta * angular_frequency + 1i * angular_frequency * sqrt(1 - zeta^2);
    p2 = -zeta * angular_frequency - 1i * angular_frequency * sqrt(1 - zeta^2);
    fprintf('Desired pole locations: %.4f + %.4fj, %.4f - %.4fj\n', real(p1), imag(p1), real(p2), imag(p2));

end
