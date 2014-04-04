function viewmotion(mu)
x = double(mu(1, :));
y = double(mu(2, :));
z = double(mu(3, :));
plot3(x, y, z);
xlabel('x');
ylabel('y');
text(x, y, z, num2str((1 : size(mu, 2))'));
end