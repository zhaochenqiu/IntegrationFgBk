function re_value = fun(n)

if n == 1
	re_value = n;
else
	re_value = fun(n - 1) + n;
end

